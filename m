Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389AbbANJGD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 04:06:03 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:50399 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbbANJF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 04:05:59 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Olof Johansson <olof@lixom.net>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        ARM Maintainers <arm@kernel.org>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: re-fromat AT91 part to match other entries
Date: Wed, 14 Jan 2015 10:05:08 +0100
Message-ID: <2263559.r5MiMeqJt6@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20150113234759.GH3843@piout.net>
References: <20150112224203.GL22090@quad.lixom.net> <20150113230956.GA15087@quad.lixom.net> <20150113234759.GH3843@piout.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:gacbGRI68Fi/IZkOkGItewO9Nlre78EjFh70AYiUhtYbZQ0l4Po
 2w6z6BeKA+o7zK1rSkaI9omoFyHEM11fAVqLinXbOg6NuSBLwZkfxWnCouM7SGO30P0yaAP
 ophHYaWjBptKuV4hy1Ws9GpG7Qo7YI0MOPJs3m8gRI+Ecs0xABDufHUioaFjJQQMAKXtdoe
 VALNF0dAZDF6V+1oZaJpg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 January 2015 00:47:59 Alexandre Belloni wrote:
> 
> On 13/01/2015 at 15:09:56 -0800, Olof Johansson wrote :
> > On Tue, Jan 13, 2015 at 03:43:00PM +0100, Nicolas Ferre wrote:
> > > The entries are separated as ARM V4/V5 and ARM V7 as some other per-SoC config
> > > options may be removed in the near future.
> > > 
> > > Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> > > ---
> > > Hi Olof,
> > > 
> > > This is an attempt to match other ARM SoC families format.
> > > If you feel that the patch can be good, do not hesitate to take it yourself. I
> > > don't plan to integrate it in any of my pull-request so it can appear quickly in
> > > arm-soc and can be used by everyone.
> > 
> > Hi,
> > 
> > If you see what Peter did, he split up the rules per-SoC based on how
> > things were selectable in Kconfig. Since you seem to have the Kconfig
> > entries already, how about doing the same? That way the same information
> > w.r.t. SoC family that you have as comments isn't lost either.
> > 
> 
> You didn't see the patch set yet because it depends on a lot of other
> series still being discussed but after the switch to multiplatform, the
> only config option left will be SOC_AT91RM9200, SOC_AT91SAM9 (both
> under SOC_SAM_V4_V5) and SOC_SAMA5, under SOC_SAM_V7.
> 
> That's our plan, unless you feel that we should keep one config option
> per SoC.

With the patches that I prepared last year, all of AT91SAM9 becomes
one small file, so there really isn't any need to have separate Kconfig
options.

	Arnd
