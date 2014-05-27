Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbaE0ShK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 14:37:10 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:54318 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbaE0ShI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 14:37:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Jingoo Han <jg1.han@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mohit Kumar <mohit.kumar@st.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v1 3/5] phy: pci serdes phy driver for keystone
Date: Tue, 27 May 2014 20:36:32 +0200
Message-ID: <4735720.XlAWNkHzF3@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5384C17E.5060806@ti.com>
References: <1400169692-9677-1-git-send-email-m-karicheri2@ti.com> <9828919.7tZBgbvqj4@wuerfel> <5384C17E.5060806@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:gctpLMWUd7sWdAnjyrS3IACMhegIh0ah+pD3iUfOhhc
 qHJbxAX9Q7JpqpYYvFpQ6o9flleASKjbKOObtxwPyNijYKteOn
 m08AHUrvFoA9qHbkX3IZe4Dc6BhF4cMvhFwYIyNXXyinF7CP1m
 djwtcWbRs0smkmBy58gau1/VCUAMd3zu68/viwUp8V/b17+jLx
 nHLs2RGums+nSXF34oTNg3ltsjI2CZ4tHVcd12LWQq1sB3Xd0w
 S1m32m3Q0YBvizn+gOEuVgTadzIy8VNnsFCZxR5bOUb9CUiFXK
 YeW0Jw6+68GpeD9hIxkKFRl9Ob/SNF/iXvUqvF4Yp/MTtHQg5W
 bM+YMvuEa7/SAxNmi658=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 May 2014 12:46:54 Murali Karicheri wrote:
> I have checked the register set of the following drivers under 
> drivers/phy from the
> master branch (v3.15-rc6) using the registers set available with us 
> internally and
> I can't find a match.
> 
> phy-exynos5250-sata.c  phy-exynos-mipi-video.c  phy-omap-usb2.c 
> phy-sun4i-usb.c
> phy-xgene.c phy-exynos4210-usb2.c  phy-exynos5250-usb2.c phy-mvebu-sata.c
> phy-samsung-usb2.c  phy-ti-pipe3.c phy-bcm-kona-usb2.c phy-exynos4x12-usb2.c
>   phy-exynos-dp-video.c  phy-omap-control.c  phy-twl4030-usb.c
> 
> So there is no duplication.

Ok, thanks a lot for checking!

	Arnd
