Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574Ab3HZIze (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 04:55:34 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:60307 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391Ab3HZIza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 04:55:30 -0400
X-AuditID: cbfee68f-b7f656d0000058e3-71-521b180134b5
From: Jingoo Han <jg1.han@samsung.com>
To: "'Kishon Vijay Abraham I'" <kishon@ti.com>
Cc: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-fbdev@vger.kernel.org,
        "'devicetree'" <devicetree@vger.kernel.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Sylwester Nawrocki'" <s.nawrocki@samsung.com>,
        "'Felipe Balbi'" <balbi@ti.com>, "'Tomasz Figa'" <t.figa@samsung.com>,
        "'Jean-Christophe PLAGNIOL-VILLARD'" <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH V7 0/3] Generic PHY driver for the Exynos SoC DP PHY
Date: Mon, 26 Aug 2013 17:55:29 +0900
Message-id: <003e01cea23a$03aac850$0b0058f0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6iOgN7MgvkoL3hRgS3gzfXOa2c2A==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsVy+t8zY11GCekggzd7lC0O3q+3eHlI02L+
	kXOsFs2L17NZXF54idWid8FVNosLT3vYLE70fWC1uLxrDpvFjPP7mCzWPXzBZHH4TTurxfoZ
	r1ks1s+/xebA5/Hqwh0Wj/1z17B79G1Zxehx/MZ2Jo/Pm+QCWKO4bFJSczLLUov07RK4Mrb1
	X2Up2C1Zcf7LBMYGxhPCXYwcHBICJhLHlpp0MXICmWISF+6tZ+ti5OIQEljGKDHrwjpmiISJ
	xIRTU5khEosYJW7s3ARV9YtRYtv2dywgVWwCahJfvhxmB7FFBHQkFp5eD9bBLPCGWeLN2ZVs
	IAlhAReJx8tngRWxCKhKLHrxkhXE5hWwlTjd8pURwhaU+DH5HthQZgEtic3bmlghbHmJzWve
	MkOcrS7x6K8uxC49ifv9R6FKRCT2vXjHCLJXQqCVQ6KpbxUrxC4BiW+TD7FA9MpKbDoA9Zmk
	xMEVN1gmMIrNQrJ5FpLNs5BsnoVkxQJGllWMoqkFyQXFSelFxnrFibnFpXnpesn5uZsYIRHd
	v4Px7gHrQ4zJQOsnMkuJJucDE0JeSbyhsZmRhamJqbGRuaUZacJK4rxqLdaBQgLpiSWp2amp
	BalF8UWlOanFhxiZODilGhgD+yym79i8k+NTx9pzkyw6alSXsfzQ3TMvpIeh+lOuawuLvZGL
	ytQLXTktDeuMJydPWCcU+lb6cIpdwprVvIdurny0nzmsfn14kUbYn/QQs/gdgbmfWw48PiVx
	NIi51i3Fi73wMO/x1OuFtvVd788sSg00nb9Mu/LqGYevgoYPBDZXbhRnyVNiKc5INNRiLipO
	BADLhzCD/gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJKsWRmVeSWpSXmKPExsVy+t9jAV1GCekggz/XZC0O3q+3eHlI02L+
	kXOsFs2L17NZXF54idWid8FVNosLT3vYLE70fWC1uLxrDpvFjPP7mCzWPXzBZHH4TTurxfoZ
	r1ks1s+/xebA5/Hqwh0Wj/1z17B79G1Zxehx/MZ2Jo/Pm+QCWKMaGG0yUhNTUosUUvOS81My
	89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgA5VUihLzCkFCgUkFhcr6dthmhAa
	4qZrAdMYoesbEgTXY2SABhLWMWZs67/KUrBbsuL8lwmMDYwnhLsYOTkkBEwkJpyaygxhi0lc
	uLeerYuRi0NIYBGjxI2dm6CcX4wS27a/YwGpYhNQk/jy5TA7iC0ioCOx8PR6ZpAiZoE3zBJv
	zq5kA0kIC7hIPF4+C6yIRUBVYtGLl6wgNq+ArcTplq+MELagxI/J98CGMgtoSWze1sQKYctL
	bF7zFmgoB9BJ6hKP/upC7NKTuN9/FKpERGLfi3eMExgFZiGZNAvJpFlIJs1C0rKAkWUVo2hq
	QXJBcVJ6rpFecWJucWleul5yfu4mRnDCeCa9g3FVg8UhRgEORiUe3gA26SAh1sSy4srcQ4wS
	HMxKIrzmokAh3pTEyqrUovz4otKc1OJDjMlAj05klhJNzgcms7ySeENjEzMjSyMzCyMTc3PS
	hJXEeQ+2WgcKCaQnlqRmp6YWpBbBbGHi4JRqYNyqHXE/7+u5pPuCXQf/zp36vOC9b2Lf3aLH
	TfFJjfedrdfvK+gsS5jG8HDX4ncsUeLNcVM3C9TGPt6QXOI8dW9ogPjMSxqi/SyW9gt8zBty
	nzAHurzozA1b8Dpl092VpYXLLlV7zZubbXLvQPuR5w8PLJvH+F7WKXVVrdb5Q0INfO63VfdM
	7FNiKc5INNRiLipOBACuOvVOXAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds a simple driver for the Samsung Exynos SoC
series DP transmitter PHY, using the generic PHY framework [1].
Previously the DP PHY used an internal DT node to control the PHY
power enable bit.

These patches was tested on Exynos5250.

This PATCH v7 follows:
 * PATCH v6, sent on July, 9th 2013
 * PATCH v5, sent on July, 8th 2013
 * PATCH v4, sent on July, 2nd 2013
 * PATCH v3, sent on July, 1st 2013
 * PATCH v2, sent on June, 28th 2013
 * PATCH v1, sent on June, 28th 2013

Changes from v6:
  * Re-based on git://git.kernel.org/pub/scm/linux/kernel/git/kishon/linux-phy.git

Changes from v5:
  * Re-based on git://gitorious.org/linuxphy/linuxphy.git

Changes from v4:
  * Marked original bindings as deprecated in 'exynos_dp.txt'
  * Fixed typo of commit message.
  * Added Tomasz Figa's Reviewed-by.

Changes from v3:
  * Added OF dependancy.
  * Removed redundant local variable 'void __iomem *addr'.
  * Removed unnecessary dev_set_drvdata().
  * Added a patch that remove non-DT support for Exynos
    Display Port driver.
  * Removed unnecessary 'struct exynos_dp_platdata'.
  * Kept supporting the original bindings for DT compatibility.

Changes from v2:
  * Removed redundant spinlock
  * Removed 'struct phy' from 'struct exynos_dp_video_phy'
  * Updated 'samsung-phy.txt', instead of creating
    'samsung,exynos5250-dp-video-phy.txt'.
  * Removed unnecessary additional specifier from 'phys'
    DT property.
  * Added 'phys', 'phy-names' properties to 'exynos_dp.txt' file.
  * Added Felipe Balbi's Acked-by.

Changes from v1:
  * Replaced exynos_dp_video_phy_xlate() with of_phy_simple_xlate(),
    as Kishon Vijay Abraham I guided.
  * Set the value of phy-cells as 0, because the phy_provider implements
    only one PHY.
  * Removed unnecessary header include.
  * Added '#ifdef CONFIG_OF' and of_match_ptr macro.

This series depends on the generic PHY framework [1]. These patches
refer to Sylwester Nawrocki's patches about Exynos MIPI [2].

[1] http://lwn.net/Articles/564188/
[2] http://www.spinics.net/lists/linux-samsung-soc/msg20098.html

Jingoo Han (3):
  phy: Add driver for Exynos DP PHY
  video: exynos_dp: remove non-DT support for Exynos Display Port
  video: exynos_dp: Use the generic PHY driver

 .../devicetree/bindings/phy/samsung-phy.txt        |    7 ++
 .../devicetree/bindings/video/exynos_dp.txt        |   17 +--
 drivers/phy/Kconfig                                |    7 ++
 drivers/phy/Makefile                               |    7 +-
 drivers/phy/phy-exynos-dp-video.c                  |  111 ++++++++++++++++
 drivers/video/exynos/Kconfig                       |    2 +-
 drivers/video/exynos/exynos_dp_core.c              |  132 ++++++--------------
 drivers/video/exynos/exynos_dp_core.h              |  110 ++++++++++++++++
 drivers/video/exynos/exynos_dp_reg.c               |    2 -
 include/video/exynos_dp.h                          |  131 -------------------
 10 files changed, 286 insertions(+), 240 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/samsung-phy.txt
 create mode 100644 drivers/phy/phy-exynos-dp-video.c
 delete mode 100644 include/video/exynos_dp.h
--
1.7.10.4

