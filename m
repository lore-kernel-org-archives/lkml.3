Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757729Ab3D2Nej (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 09:34:39 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:53467 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757298Ab3D2Neh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 09:34:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Gupta, Pekon" <pekon@ti.com>
Subject: Re: [PATCH 21/21] mtd: omap2: allow bulding as a module
Date: Mon, 29 Apr 2013 15:34:10 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Tony Lindgren <tony@atomide.com>, "Mohammed, Afzal" <afzal@ti.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1366734653-488286-1-git-send-email-arnd@arndb.de> <20130423180320.GJ10155@atomide.com> <20980858CB6D3A4BAE95CA194937D5E73E9BCFAE@DBDE04.ent.ti.com>
In-Reply-To: <20980858CB6D3A4BAE95CA194937D5E73E9BCFAE@DBDE04.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304291534.10539.arnd@arndb.de>
X-Provags-ID: V02:K0:MIy0SF4cap3z3J9gW6tq5Lw+WEMLg+eEnn+ObM0B8fg
 9lRU6PJw9i4Ych5xtJsoG4MswDMOc+WsrPL6JPUK5ivBLiF3ES
 xCx/TAXmNg4hch6OmG3Ok2xOo80tvXaNkJo/WXFczZwZ1+Gc0W
 I88aHaXmf3MJ0KNdLb+chr3YiR56M4PBYM1ZbO6OdsJGRUf1rU
 LvOo7lDg3sNm6nwNsInpxorb2VQ59sVT+AO9nBxHHDLmu6QJM/
 kYb5sK7xz/uqZul6n/6wPd7sRgotXohqhO+LRikKapLECQxEpz
 QcjRn95q+I9A/tIlKBQmrk3oOcXIVuUD0rGbu8XXKO9LCmxNjC
 pPEi851UZiF5IoqxAuW0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 April 2013, Gupta, Pekon wrote:
> [Pekon]: 
> ELM module is required in for Hardware based ECC correction for 
> NAND devices. And this driver has a very small foot-print.
> 
> The only cases this drives would not be used are:
> (a) Using S/W based ECC scheme, which have vey high CPU utilization
> (b) Using single bit ECC scheme, which are becoming obsolete due to
>  increasing NAND densities.
> For most of the cases ELM module will be used with nand-driver. So
> there should be no harm in having this module as built-in, if not used
> in 10% of the use-cases.
> 
> Thus I think it's better to keep this module tied to GPMC module, 
> rather than independent control via KConfig.
> And user should just selects which ECC scheme he would like to
> use via DT, without worrying about KConfig options.

Sorry, I'm lost here and have no idea what you are actually suggesting
we do. Can you phrase that as a patch?

Unless you come up with a better solution, I would still like to queue
up my patch since it fixes an annoying bug and seems to have no downsides.
 
> I'm working in cleaning up omap2-nand driver to remove some 
> redundancies. So would like to know your feedback on same..

Sure, just Cc me on your patches.

	Arnd
