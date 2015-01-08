Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305AbbAHU4e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 15:56:34 -0500
Received: from gloria.sntech.de ([95.129.55.99]:36967 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757180AbbAHU4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 15:56:32 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Abhilash Kesavan <kesavan.abhilash@gmail.com>
Cc: Rob Herring <robherring2@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Tony Lindgren <tony@atomide.com>, linux-rockchip@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>,
        "shc_work@mail.ru" <shc_work@mail.ru>,
        "nicoleotsuka@gmail.com" <nicoleotsuka@gmail.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "padma.v@samsung.com" <padma.v@samsung.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "shawn.guo@freescale.com" <shawn.guo@freescale.com>,
        "bcousson@baylibre.com" <bcousson@baylibre.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "kgene@kernel.org" <kgene@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>
Subject: Re: [PATCH 2/2] misc: sram: switch to ioremap_wc from ioremap
Date: Thu, 08 Jan 2015 21:56:04 +0100
Message-ID: <2101240.CsKVRjX3M8@phil>
User-Agent: KMail/4.14.2 (Linux/3.16-3-amd64; KDE/4.14.1; x86_64; ; )
In-Reply-To: <CAM4voakHnwRzVsYYO2Dd2f9_PxZGqvqT8xveA-Y6N4ReOfhdmw@mail.gmail.com>
References: <1418266726-12004-1-git-send-email-a.kesavan@samsung.com> <CAL_JsqJwdr7WvzLqPmui3N4H-wVgSURN6wYD=dm1HyU2HUmXOg@mail.gmail.com> <CAM4voakHnwRzVsYYO2Dd2f9_PxZGqvqT8xveA-Y6N4ReOfhdmw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Abhilash,

Am Donnerstag, 8. Januar 2015, 21:00:57 schrieb Abhilash Kesavan:
> Thanks for the confirmation regarding the i.MX chips. That leaves
> rockchip, can someone help with it please ?

sorry for being late to this.

The one current sram use-case on Rockchip boards is the SMP bringup, but that 
uses a reserved sram area. Nevertheless I tested your 2 patches on a rk3288 
board and everything still works as expected, including smp bringup,
so on Rockchip

Tested-by: Heiko Stuebner <heiko@sntech.de>


Heiko
