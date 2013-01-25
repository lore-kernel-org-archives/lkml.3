Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162Ab3AYLPH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:15:07 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:61156 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517Ab3AYLPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:15:00 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-f6-51026932cf44
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, balbi@ti.com
Subject: [PATCH 0/2] usb: dwc3: Change platform device IDs to AUTO
Date: Fri, 25 Jan 2013 16:52:00 +0530
Message-id: <1359112922-2247-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsWyRsSkVtcokynQoP2SlsXlXXPYLGYv6Wex
	WLSsldmB2ePzJrkAxigum5TUnMyy1CJ9uwSujJOPbjAXHGKtODz5MXsD40qWLkZODgkBE4l7
	p/YxQdhiEhfurWfrYuTiEBJYyihx8NMNoAQHWNGnj7wQ8UWMEvt2boIqmswkMbPrETtIN5uA
	rkTT212MILaIgKzE4Su/mUGamQUyJGZcYAUJCws4SfzraGcGsVkEVCWOL9oNtphXwF3i/dNn
	UAcpSLy5/YwZZL6EwBk2iWeHV7BANAhIfJt8iAXiIFmJTQeYIeolJQ6uuMEygVFwASPDKkbR
	1ILkguKk9FxDveLE3OLSvHS95PzcTYzAIDv975nUDsaVDRaHGAU4GJV4eC3SGAOFWBPLiitz
	DzFKcDArifDKmDAFCvGmJFZWpRblxxeV5qQWH2JMBlo+kVlKNDkfGAF5JfGGxibmpsamlkZG
	ZqampAkrifMynnoSICSQnliSmp2aWpBaBLOFiYNTqoFRK2Dv6kMrjuo8PeMf11OXENpZm1qR
	P2uX1vvpTwLWLE+z3F4y/fnXSbnqq7hmyMevebiGN75x+voHEgkJWwq29PMk2J879WnT95/P
	eJ9OuJWe9CX32YwsDe9a/xf+fFyCO1u2JBjsncD7j0dEPYSjxcDzu/bR64baF7N5M/805XGW
	Ky2/cahSiaU4I9FQi7moOBEAOe/uRHYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsVy+t9jAV2jTKZAg84f0haXd81hs5i9pJ/F
	YtGyVmYHZo/Pm+QCGKMaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNT
	bZVcfAJ03TJzgOYrKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwlrGDNOPrrB
	XHCIteLw5MfsDYwrWboYOTgkBEwkPn3k7WLkBDLFJC7cW8/WxcjFISSwiFFi385NUM5kJomZ
	XY/YQarYBHQlmt7uYgSxRQRkJQ5f+c0MMohZIENixgVWkLCwgJPEv452ZhCbRUBV4vii3Uwg
	Nq+Au8T7p89YIJYpSLy5/Yx5AiP3AkaGVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjBIfxM
	agfjygaLQ4wCHIxKPLwWaYyBQqyJZcWVuYcYJTiYlUR4ZUyYAoV4UxIrq1KL8uOLSnNSiw8x
	JgNtn8gsJZqcD4yvvJJ4Q2MTc1NjU0sTCxMzS9KElcR5GU89CRASSE8sSc1OTS1ILYLZwsTB
	KdXAuLmg3fTzmXOLF7RGBD8vWd7zSrlJLemuRPnJcq1DPdUba/R6nOyW5bUJuf5T3jLBJW3G
	mUybbd+s3yoH9mk92fj35ZK8k7MfTdsYu0Tl87Z+r4c/Wl/v/cS+IqhwMpPKWukLGQ+ePjyb
	dvCYxv63tYELl6cYL879ZnKiZfEJVY7Et0EhWx/sXaLEUpyRaKjFXFScCADXJW3HpQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Multiple dwc3 controllers will try to allocate multiple platform
devices for no_op_xceive (for usb2_phy and usb3_phy) as well as
xhci-hcd.
This patchset updates the platform devices IDs for allocated
devices to AUTO in order to support multiple dwc3 controllers.

This is based on 'dwc3' branch of Felipe Balbi's usb tree.

Vivek Gautam (2):
  usb: dwc3: exynos/omap: Change platform device IDs for no_op_xceive
    to AUTO
  usb: dwc3: host: Change platform device ID for xhci-hcd to AUTO

 drivers/usb/dwc3/dwc3-exynos.c |    4 ++--
 drivers/usb/dwc3/dwc3-omap.c   |    4 ++--
 drivers/usb/dwc3/host.c        |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

-- 
1.7.6.5

