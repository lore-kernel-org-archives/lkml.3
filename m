Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134AbaD1Kq6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 06:46:58 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:52629 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260AbaD1Kqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 06:46:54 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-69-535e319c32e4
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, t.figa@samsung.com, davem@davemloft.net
Subject: [PATCH 0/7 v8] crypto:s5p-sss: Add Device tree and Exynos support
Date: Mon, 28 Apr 2014 16:14:52 +0530
Message-id: <1398681899-20782-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsWyRsSkTneOYVywwYaVwhYvD2lazDnfwmLR
	/UrG4v69n0wWl3fNYbOYcX4fk8Wibf+ZLdbPeM1icXbOISYHTo8tK28yeeycdZfdY9sBVY++
	LasYPT5vkgtgjeKySUnNySxLLdK3S+DKOLbmBWvBLp6KVTM+sjcwvufsYuTkkBAwkdg9/wwj
	hC0mceHeejYQW0hgKaPExc9CMDV329ewQsSnM0r0HQOq5wKy+5kkdn79BZZgEzCTOLhoNTuI
	LSLgLPG7GaSBi4NZYB2jxKc3h5lAEsICXhLnXk8C28AioCqxbXMbWJxXwFXi1dHTQHEOoG0K
	EnMm2YD0Sgj0s0ssvXecGaJeQOLb5EMsEDWyEpsOMEMcJylxcMUNlgmMggsYGVYxiqYWJBcU
	J6UXGeoVJ+YWl+al6yXn525iBIbw6X/Pencw3j5gfYgxGWjcRGYp0eR8YAzklcQbGpsZWZia
	mBobmVuakSasJM6b9DApSEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAOj88nsr7d45n4xnuzp
	8fzigV+P+K+t9PgXdWXDa1ajGZ7JG3iZC9v/TNm3Lu/H/tvPubf6ZP5i3TaLZ+tltzy9L44t
	LYZ3OuS3Tt3fvPD2Y5OEmYbTYwJPmW93Faxp4V+S/C/da/Psto8zead5zZ3ifP9u0FKDqK8P
	cl/MumP0bo+O0BJziQvlj5RYijMSDbWYi4oTAamlJTh3AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsVy+t9jQd05hnHBBmuvcFu8PKRpMed8C4tF
	9ysZi/v3fjJZXN41h81ixvl9TBaLtv1ntlg/4zWLxdk5h5gcOD22rLzJ5LFz1l12j20HVD36
	tqxi9Pi8SS6ANaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnF
	J0DXLTMH6BwlhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8axNS9YC3bx
	VKya8ZG9gfE9ZxcjJ4eEgInE3fY1rBC2mMSFe+vZQGwhgemMEn3HGLsYuYDsfiaJnV9/gRWx
	CZhJHFy0mh3EFhFwlvjdDNLMxcEssI5R4tObw0wgCWEBL4lzryeBTWIRUJXYtrkNLM4r4Crx
	6uhpoDgH0DYFiTmTbCYwci9gZFjFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERwjz6R2MK5s
	sDjEKMDBqMTDGzEnNliINbGsuDL3EKMEB7OSCO9+ibhgId6UxMqq1KL8+KLSnNTiQ4zJQMsn
	MkuJJucD4zevJN7Q2MTc1NjU0sTCxMySNGElcd4DrdaBQgLpiSWp2ampBalFMFuYODilGhi1
	V9q0BM9sYljwddFMt+LJy/XzvxQb77nP4XIk4pZlTMi29zcEzDU0FL3rXhSo8q2dXx4fym3Y
	UOf+UFFr0SU24z2NOyuyuq3lxc7L3JT+8ce9LOib3kdvXt/6oDk2Z6IvpgjeXs63QfT2z3l5
	6c7nYvOvubEq++4+v2xah7/0o+NOf13P2iixFGckGmoxFxUnAgDnzwIx1QIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SSS module on Exynos4210, Exynos5250 and Exynos5420 SoCs has added
features to the one on S5PV210. However with minor changes the s5p-sss.c
driver can be reused to support SSS modules on Exynos4 and 5 SoCs.

This patch set
1. Adds device tree support to the s5p-sss.c driver and Documentation
2. Adds code to support SSS module on Exynos4 and 5 SoCs
3. Adds variant struct to handle the differences in SSS modules
4. Adds clk_prepare/clk_unprepare clocks to the s5p-sss.c driver

Note: Compatible "exynos4210-secss" should work for Exynos4412 and
      Exynos5260 (Exynos5260, for which ARCH code is under review)
I couldn't test on Exynos4412 and Exynos4210 boards, Should be able to
test with addition of DT node and clocks support.

These patches are under review at
https://lkml.org/lkml/2014/2/17/124

Naveen Krishna Chatradhi (7):
  crypto:s5p-sss: Use platform_get_irq() instead of _byname()
  crypto:s5p-sss: Kconfig: Let Exynos SoCs select SSS driver
  crypto:s5p-sss: Look for the next request in the queue
  crypto:s5p-sss: Add device tree support
  crypto:s5p-sss: Add support for SSS module on Exynos
  crypto:s5p-sss: validate iv before memcpy
  crypto:s5p-sss: Use clk_prepare/clk_unprepare

 .../devicetree/bindings/crypto/samsung-sss.txt     |   35 +++++
 drivers/crypto/Kconfig                             |    6 +-
 drivers/crypto/s5p-sss.c                           |  145 +++++++++++++++-----
 3 files changed, 150 insertions(+), 36 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/samsung-sss.txt

-- 
1.7.9.5

