Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165Ab3AVLEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 06:04:21 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:61141 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600Ab3AVLEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 06:04:20 -0500
X-AuditID: cbfec7f4-b7f6d6d000001620-b5-50fe7232d171
Message-id: <50FE722E.1030901@samsung.com>
Date: Tue, 22 Jan 2013 12:04:14 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 14/33] media: Convert to devm_ioremap_resource()
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
 <1358762966-20791-15-git-send-email-thierry.reding@avionic-design.de>
In-reply-to: <1358762966-20791-15-git-send-email-thierry.reding@avionic-design.de>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnluLIzCtJLcpLzFFi42I5/e/4VV2jon8BBj3beC0u75rDZtGzYSur
	A5PH501yAYxRXDYpqTmZZalF+nYJXBkvLnkUXOeq2PnmAUsD43OOLkYODgkBE4kbF3S7GDmB
	TDGJC/fWs3UxcnEICSxllPh17CY7hPOJUWL5n3Z2kCpeAS2JK+dnsYDYLAKqEic7z7CC2GwC
	hhK9R/sYQWxRgQCJxUvOQdULSvyYfI8FZJmIgKnEt3kiIDOZBaYwSbTO62QGiQsLuEgcf8gP
	sWsWo8SmpgfMIL2cAiESE/oesYHYzAI6Evtbp0HZ8hKb17xlnsAIVI2wYhaSsllIyhYwMq9i
	FE0tTS4oTkrPNdQrTswtLs1L10vOz93ECAnELzsYFx+zOsQowMGoxMP74P7fACHWxLLiytxD
	jBIczEoivILB/wKEeFMSK6tSi/Lji0pzUosPMTJxcEo1MBpI/tJZXNa17Mb5Xev/WCzQVd/z
	dZLcqZ92K6vPLtnHH/CQ91TkcxnTqS1JOTN2JmVcf3JSnHkSa7XtXP5XcTNO8OxusmJ29Aw4
	KmMY2H/rS/+SY/LRW+c67g5wPPPvh8u67X2h5y+t2PZW6lS+TadElcuibwGPCj+7l3X21V3N
	YVk0K8Tliq0SS3FGoqEWc1FxIgCzaC7xIgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 01/21/2013 11:09 AM, Thierry Reding wrote:
> Convert all uses of devm_request_and_ioremap() to the newly introduced
> devm_ioremap_resource() which provides more consistent error handling.
> 
> devm_ioremap_resource() provides its own error messages so all explicit
> error messages can be removed from the failure code paths.
> 
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: linux-media@vger.kernel.org
> ---
>  drivers/media/platform/exynos-gsc/gsc-core.c   |  8 +++-----
>  drivers/media/platform/mx2_emmaprp.c           |  6 +++---
>  drivers/media/platform/s3c-camif/camif-core.c  |  8 +++-----
>  drivers/media/platform/s5p-fimc/fimc-core.c    |  8 +++-----
>  drivers/media/platform/s5p-fimc/fimc-lite.c    |  8 +++-----
>  drivers/media/platform/s5p-fimc/mipi-csis.c    |  8 +++-----
>  drivers/media/platform/s5p-g2d/g2d.c           |  8 +++-----
>  drivers/media/platform/s5p-jpeg/jpeg-core.c    |  8 +++-----
>  drivers/media/platform/s5p-mfc/s5p_mfc.c       |  8 +++-----
>  drivers/media/platform/soc_camera/mx2_camera.c | 12 ++++++------
>  10 files changed, 33 insertions(+), 49 deletions(-)

That's a nice cleanup. For exynos-gsc, s3c-camif, s5p-* drivers

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

--

Thanks,
Sylwester
