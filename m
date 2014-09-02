Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122AbaIBNtQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 09:49:16 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:47794 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972AbaIBNtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 09:49:15 -0400
Message-ID: <5405CAD4.4090502@atmel.com>
Date: Tue, 2 Sep 2014 15:49:08 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [GIT PULL 4/4] at91: dt for 3.18 #2
References: <1409593127-24049-1-git-send-email-nicolas.ferre@atmel.com> <1409593127-24049-4-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1409593127-24049-4-git-send-email-nicolas.ferre@atmel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2014 19:38, Nicolas Ferre :
> Arnd, Olof, Kevin,
> 
> A little bit more material for the DT branch. I didn't want to the one I've
> just sent you because this material is not related to the big cleanup addressed
> by previous 3 pull-requests.
> It is very basic and simple DT updates and a use of phy fixup infrastructure
> that is now present in phy subsystem.
> 
> Thanks, best regards,
> 
> The following changes since commit 464d6e18639c4347dafd8dbcee270674dd3d8fba:
> 
>   Merge tag 'at91-dt-for-3.17' of git://git.kernel.org/pub/scm/linux/kernel/git/mripard/linux (2014-08-19 16:04:10 -0500)
> 
> are available in the git repository at:
> 
> 
>   git://github.com/at91linux/linux-at91.git tags/at91-dt2

FYI, I've just pushed a branch to show the conflict resolution while
merging this tag with the tree previous pull-requests:

https://github.com/at91linux/linux-at91/commits/at91-3.18-resolved

or:

git://github.com/at91linux/linux-at91.git at91-3.18-resolved

Best regards,

> for you to fetch changes up to 5f8157309624929e05ece846d3ca8a3a64988378:
> 
>   ARM: at91: remove phy fixup for sama5d3xek boards (2014-09-01 19:30:44 +0200)
> 
> ----------------------------------------------------------------
> Second batch of AT91 DT patches for 3.18:
> - 2 little fixes for at91sam9x5 and at91sam9n12ek
> - removal of a board specific hook for sama5d3xek about phy fixup
>   replaced with proper DT property definition.
> 
> ----------------------------------------------------------------
> Alexandre Belloni (1):
>       ARM: at91/dt: sam9x5: fix ADC compatible string
> 
> Bo Shen (1):
>       ARM: at91/dt: sam9n12ek: ohci: add port and vbus property
> 
> Boris BREZILLON (2):
>       ARM: at91/dt: describe rgmii ethernet phy connected to sama5d3xek boards
>       ARM: at91: remove phy fixup for sama5d3xek boards
> 
>  arch/arm/boot/dts/at91sam9n12ek.dts |  2 ++
>  arch/arm/boot/dts/at91sam9x5.dtsi   |  2 +-
>  arch/arm/boot/dts/sama5d3xcm.dtsi   | 30 ++++++++++++++++++++++++++++++
>  arch/arm/mach-at91/board-dt-sama5.c | 22 ----------------------
>  4 files changed, 33 insertions(+), 23 deletions(-)
> 


-- 
Nicolas Ferre
