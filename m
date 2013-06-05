Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236Ab3FEVAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:00:21 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45244 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194Ab3FEVAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:00:17 -0400
Message-ID: <51AFA6DD.3000202@wwwdotorg.org>
Date: Wed, 05 Jun 2013 15:00:13 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "jonsmirl@gmail.com" <jonsmirl@gmail.com>
CC: Luke Kenneth Casson Leighton <lkcl@lkcl.net>,
        devicetree-discuss <devicetree-discuss@ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        debian-arm@lists.debian.org, debian-release@lists.debian.org,
        Linux on small ARM machines 
	<arm-netbook@lists.phcomp.co.uk>,
        ARM Linux Mailing List <linux-arm-kernel@lists.infradead.org>,
        debian-kernel@lists.debian.org
Subject: Re: getting allwinner SoC support upstream (was Re: Uploading linux
 (3.9.4-1))
References: <CAPweEDx3mAy40BZrzrKPRbvg7vKMj7KevDQ3m_v4p6Yo50eSGg@mail.gmail.com> <CAKON4OxDD5orX2w-_+d5kawTGXbE3KKj2QLERo9m7=NiUSXhgQ@mail.gmail.com>
In-Reply-To: <CAKON4OxDD5orX2w-_+d5kawTGXbE3KKj2QLERo9m7=NiUSXhgQ@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2013 02:46 PM, jonsmirl@gmail.com wrote:
> On Wed, Jun 5, 2013 at 3:46 PM, Luke Kenneth Casson Leighton
> <lkcl@lkcl.net <mailto:lkcl@lkcl.net>> wrote:
...
>     the detect line, which is the write-protect line, to setting the DRAM
>     clock timings, saying which kernel driver must be loaded to support
>     the touchscreen, enabling debugging, JTAG, naming the GPIOs for easy
>     and convenient use in the kernel code: basically there isn't a single
>     piece of hardware on the allwinner SoC family which *isn't*
>     reconfigureable through script.fex... and they've even integrated it
>     into u-boot *and* their low-level (early) bootloader as well [which
> 
> 
> Device tree support has been integrated into uboot for about five years now.

There are two aspects to DT support in U-Boot:

1) Having U-Boot pass a DT to the kernel, possibly manipulating a few
properties on the way, e.g. RAM size. As you say, this has been around a
while.

2) Having U-Boot itself read a DT and configure itself, just like the
kernel does. This is relatively new, and only supported by a few boards
(all Tegra to some extent, and a couple each Samsung Exynos and Xilinx
boards). I suspect/guess this is the kind of thing that Luke was
referring to re: U-Boot fex integration.
