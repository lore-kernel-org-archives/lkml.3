Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbaGVHg4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 03:36:56 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:58184 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbaGVHgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 03:36:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Olof Johansson <olof@lixom.net>, Matt Porter <mporter@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org, Gregory Fong <gregory.0xf0@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH v8 00/11] ARM: brcmstb: Add Broadcom STB SoC support
Date: Tue, 22 Jul 2014 09:35:45 +0200
Message-ID: <5675728.WLk3P96IBM@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1405976886-27807-1-git-send-email-computersforpeace@gmail.com>
References: <1405976886-27807-1-git-send-email-computersforpeace@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:iCFYnM3/6Cn9BJ+lH5L22U2Md2MMTSy8NmpJ/sBWjKK
 5NARssT8ZL02ZJcN4/Gc0R0GrdgUOuZjfYr9cXm8yhINIUsl+e
 rzTIq7pkEP59/rPOHEweN+FL4dWrYmy/DLh1DDrml/+FTYKdPu
 big6DPGYad0L6oar/966O15+dKRK5c1uL7iYdhSFPvjxYipwhr
 PdA6piPSpeXc+HtRkflIbGmowNETqZvpohx+GaTstkWUCLSdlu
 DWyZ/sr+znQ9fn6TM1Q0UjTcpXw6Bo27EWHv5dViMvYL4+lW/3
 mndoSaf466D+kM4QVE9YZ/5E+3klSXMM62Bhsj0bLnoazbGqIJ
 f3R6KITtBAvXlorD99Qc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 July 2014 14:07:55 Brian Norris wrote:
> I'm taking over the latest resubmission of this patch series.
> There are a few moderate changes for v8 (noted below), but we
> are waiting mostly for an Ack for the reboot driver.
> 
> This patchset contains the board support package for the
> Broadcom BCM7445 ARM-based SoC [1]. These changes contain a
> minimal set of code needed for a BCM7445-based board to boot
> the Linux kernel.
> 
> These changes heavily leverage the OF/devicetree framework. The
> machine is also built into the multi-platform ARMv7 image.
> 
> Changes are also available here:
> 
>   https://github.com/brcm/linux/tree/brcmstb-v8
>   git://github.com/brcm/linux.git +brcmstb-v8

Whole series

Acked-by: Arnd Bergmann <arnd@arndb.de>

I think we should try to get this merged into 3.17, it's already
taken too long and the patches look good.

Please add the core architecture patches for arch/arm into Russell's
patch tracker http://www.arm.linux.org.uk/developer/patches/.

For the platform changes in the first patch, I would prefer to have
Matt pick up the first patch, but we can also apply it directly into
arm-soc if he prefers that.

The reset driver can ideally go through the drivers/power/ maintainers,
but if they are not interested in merging it, we can also take that
through arm-soc. See also my one comment on that driver.

	Arnd
