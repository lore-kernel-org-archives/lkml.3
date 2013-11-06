Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832Ab3KFBCr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 20:02:47 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:39710 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636Ab3KFBCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 20:02:44 -0500
Date: Wed, 06 Nov 2013 10:02:42 +0900
From: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH v3 1/3] phy: Add new Exynos USB PHY driver
In-reply-to: <1383668001-19141-2-git-send-email-k.debski@samsung.com>
To: "'Kamil Debski'" <k.debski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm@vger.kernel.org, kyungmin.park@samsung.com, kishon@ti.com,
        t.figa@samsung.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com,
        gautam.vivek@samsung.com, mat.krawczuk@gmail.com,
        yulgon.kim@samsung.com, p.paneri@samsung.com,
        av.tikhomirov@samsung.com, galak@codeaurora.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
Message-id: <000c01ceda8b$e54dbef0$afe93cd0$%han@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7bit
Thread-index: Ac7aQivtGZKQYr/tTv+ZofY7RDqK4QAR9naQ
DLP-Filter: Pass
X-AuditID: cbfee690-b7f3d6d000001c4a-f0-527995325c5c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJKsWRmVeSWpSXmKPExsVy+t8zY12jqZVBBhdmmFks2X2D1WL+kXOs
	Fv1vFrJatF05yG5xeeElVosfry+wWVx42sNmcbbpDbvFtJ3/WS0u75rDZjHj/D4mi0XLWpkt
	1h65y25xtv82m8X5LZ1MFofftLNarJ/xmsWi4+xBdgchj8t9vUweO2fdZffo27KK0eP4je1M
	Hp83yQWwRnHZpKTmZJalFunbJXBlLPz4hrmgQaBi95x25gbGPTxdjJwcEgImErt/vWeFsMUk
	Ltxbz9bFyMUhJLCMUeLbg+NMMEVr/rWxQiQWMUp8fPQBquoXo8S7DQcYQarYBNQkvnw5zA5i
	iwhoSvxsOMQCUsQscIxZYvuy+2CjhATqJeb1nQBKcHBwCrhK7LldDBIWFrCTeHQeYg6LgKrE
	vdUdYCfxCthK7Gn6xQZhC0r8mHyPBcRmFtCSWL8T4jpmAXmJzWveMoOMlBBQl3j0VxfiBCOJ
	R3N+QZWLSOx78Y4R5BwJgQMcEldXP2SH2CUg8W3yIRaIXlmJTQeYIR6WlDi44gbLBEaJWUg2
	z0KyeRaSzbOQrFjAyLKKUTS1ILmgOCm9yESvODG3uDQvXS85P3cTIyRZTNjBeO+A9SHGZKD1
	E5mlRJPzgckmryTe0NjMyMLUxNTYyNzSjDRhJXFetUdJQUIC6YklqdmpqQWpRfFFpTmpxYcY
	mTg4pRoY2w9Pt9i3TdW0PWsCw4nn+TMKnaVetf3kN3rk0nH7hdpy77Wblz72yb5y2nFWZIZg
	hgr3PKf3V5zqWSsev7lh1HKcdc7H5AcVfj8ftd/sMrH8/fClSIbHkUW/al9kv9rwtfWPwSsJ
	h23FGp7haTvf5jflObxcFHKB2ZQhm2upLc+Pm6npx/4oKLEUZyQaajEXFScCAKLa3qAsAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGKsWRmVeSWpSXmKPExsVy+t9jAV2jqZVBBtePGFgs2X2D1WL+kXOs
	Fv1vFrJatF05yG5xeeElVosfry+wWVx42sNmcbbpDbvFtJ3/WS0u75rDZjHj/D4mi0XLWpkt
	1h65y25xtv82m8X5LZ1MFofftLNarJ/xmsWi4+xBdgchj8t9vUweO2fdZffo27KK0eP4je1M
	Hp83yQWwRjUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6
	ZeYAna+kUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzFj48Q1zQYNAxe45
	7cwNjHt4uhg5OSQETCTW/GtjhbDFJC7cW8/WxcjFISSwiFHi46MPUM4vRol3Gw4wglSxCahJ
	fPlymB3EFhHQlPjZcIgFpIhZ4BizxPZl95lAEkIC9RLz+k4AJTg4OAVcJfbcLgYJCwvYSTw6
	DzGHRUBV4t7qDrDNvAK2EnuafrFB2IISPybfYwGxmQW0JNbvPM4EYctLbF7zlhlkpISAusSj
	v7oQJxhJPJrzC6pcRGLfi3eMExiFZiGZNAvJpFlIJs1C0rKAkWUVo2hqQXJBcVJ6rqFecWJu
	cWleul5yfu4mRnAqeia1g3Flg8UhRgEORiUe3gT5yiAh1sSy4srcQ4wSHMxKIrxKcUAh3pTE
	yqrUovz4otKc1OJDjMlAj05klhJNzgemybySeENjEzMjSyMzCyMTc3PShJXEeQ+0WgcKCaQn
	lqRmp6YWpBbBbGHi4JRqYLRNsGXrXLSI52Fc8M7AfMZF/KIBHLsrFbznF2hxtZ7jKOhr8nzh
	MstsscS/+7IfijlSNXzXn2t0Prwiwv7qyuNbGE9LMxhO6bu/32j1idNfFzRLcH25m3aqQDOM
	yfjk1wkR5/69SJv37IsFFyvDo9vOW8Vvz3lxyHrikd7Io1vbFfoYZacsFVdiKc5INNRiLipO
	BAAzXHABiQMAAA==
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
References: <1383668001-19141-1-git-send-email-k.debski@samsung.com>
 <1383668001-19141-2-git-send-email-k.debski@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 06, 2013 1:13 AM, Kamil Debski wrote:
> 
> Add a new driver for the Exynos USB PHY. The new driver uses the generic
> PHY framework. The driver includes support for the Exynos 4x10 and 4x12
> SoC families.
> 
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  .../devicetree/bindings/phy/samsung-usbphy.txt     |   52 ++++
>  drivers/phy/Kconfig                                |   23 +-
>  drivers/phy/Makefile                               |    4 +
>  drivers/phy/phy-exynos-usb2.c                      |  234 ++++++++++++++
>  drivers/phy/phy-exynos-usb2.h                      |   87 ++++++
>  drivers/phy/phy-exynos4210-usb2.c                  |  272 ++++++++++++++++
>  drivers/phy/phy-exynos4212-usb2.c                  |  324 ++++++++++++++++++++
>  7 files changed, 995 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/devicetree/bindings/phy/samsung-usbphy.txt
>  create mode 100644 drivers/phy/phy-exynos-usb2.c
>  create mode 100644 drivers/phy/phy-exynos-usb2.h
>  create mode 100644 drivers/phy/phy-exynos4210-usb2.c
>  create mode 100644 drivers/phy/phy-exynos4212-usb2.c

[....]

> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
> index d0caae9..c87bc65 100644
> --- a/drivers/phy/Makefile
> +++ b/drivers/phy/Makefile
> @@ -7,3 +7,7 @@ obj-$(CONFIG_PHY_EXYNOS_DP_VIDEO)	+= phy-exynos-dp-video.o
>  obj-$(CONFIG_PHY_EXYNOS_MIPI_VIDEO)	+= phy-exynos-mipi-video.o
>  obj-$(CONFIG_OMAP_USB2)			+= phy-omap-usb2.o
>  obj-$(CONFIG_TWL4030_USB)		+= phy-twl4030-usb.o
> +obj-$(CONFIG_PHY_EXYNOS5250_USB)	+= phy-exynos5250-usb.o

Hi Kamil,

Would you add 'phy-exynos5250-usb.c' file? :-)

Now, I am testing Exynos5250 USB HOST with your patchset.
However, it makes error because there is no PHY driver for
Exynos5250.

  WARNING: CPU: 0 PID: 18 at drivers/phy/phy-core.c:366 phy_get+0x1e8/0x224()
  Device: exynos-ehci
  missing string
  .....

Best regards,
Jingoo Han

