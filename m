Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbaEVNym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 09:54:42 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:55922 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbaEVNyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 09:54:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>, dbaryshkov@gmail.com,
        dwmw2@infradead.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, grant.likely@linaro.org, rdunlap@infradead.org,
        linux@arm.linux.org.uk, grygorii.strashko@ti.com, olof@lixom.net,
        w-kwok2@ti.com, sboyd@codeaurora.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, m-karicheri2@ti.com,
        sergei.shtylyov@cogentembedded.com
Subject: Re: [Patch v5 0/7] Introduce keystone reset driver
Date: Thu, 22 May 2014 15:54:29 +0200
Message-ID: <5069120.YZWxxyxdrl@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <537E011B.9090902@ti.com>
References: <1400766516-14537-1-git-send-email-ivan.khoronzhuk@ti.com> <537E011B.9090902@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:qTjcJE6rCjb6BKxA6Fzct2rbt5CHjpqwBRaIwaym5jo
 x9kHGuuyC644lamkR1ivIVFUwmw9+AhLsmPF31+ZtSy5hItXG7
 I8gErLF9dRf+zZx9lUW5UzQc1c1bwvwoY83F7wYehiRGywJ4uE
 FGYAw3zNTeg+TTjGN29DtCb0+Rue1OdbCrDj5D5cuC/aSY+8dv
 VINiH72/6VFk17sbl7caIZVpi3CM8DkeIE6kB9eoXS+Z7Qx4yl
 x/3ha+2HA85ud9H9SRJqQqpa4dOjg0hovaFe6Mv5McRvFky3XC
 +KJFUOoT4b+hnVESm/kQK94mafvsX7XcTWpsvhzZ6Zpmj1gq3k
 L/LQ8YCKqeL9uarNUn+U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 May 2014 09:52:27 Santosh Shilimkar wrote:
> On Thursday 22 May 2014 09:48 AM, Ivan Khoronzhuk wrote:
> > These patches introduce keystone reset driver.
> > 
> > The keystone SoC can be rebooted in several ways. By external reset
> > pin, by soft and by watchdogs. This driver allows software reset and reset
> > by one of the watchdogs. Also added opportunity to set soft/hard reset type.
> > 
> > Based on linux-next/master
> > 
> > v5..v4
> >   power: reset: keystone-reset: introduce keystone reset driver
> >       - changed to get rsmux and rspll offsets from DT
> >   clock: keystone-pllctrl: add bindings for keystone pll controller
> >       - new patch
> >   mfd: ti-keystone-devctrl: add bindings for device state control
> >       - new patch
> >   power: reset: add bindings for keystone reset driver
> >       - corrected description of "ti,syscon-pll", "ti,syscon-dev" properties
> >       - corrected examples
> >   ARM: dts: keystone: update reset node to work with reset driver
> >       - added nodes for pll-controller and device-state-controll
> >       - added offsets to "ti,syscon-pll", "ti,syscon-dev" properties
> >
> Looks like you haven't collected Arnd's Reviewed-by tag on the patches.
> Can be added later as well while applying.
> 
> 

I was going to comment the same. Anyway here you have it for the remaining
patches:

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
