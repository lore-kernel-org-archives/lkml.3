Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445AbaLOJ7W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 04:59:22 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:51130 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbaLOJ7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 04:59:20 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: ralf@linux-mips.org, f.fainelli@gmail.com, tglx@linutronix.de,
        jason@lakedaemon.net, jogo@openwrt.org, computersforpeace@gmail.com,
        linux-mips@linux-mips.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V5 00/23] Generic BMIPS kernel
Date: Mon, 15 Dec 2014 10:58:57 +0100
Message-ID: <3160456.oe6LURFJHs@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1418422034-17099-1-git-send-email-cernekee@gmail.com>
References: <1418422034-17099-1-git-send-email-cernekee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:8yLCd7pcVWC1jdffW4Y5ri8o42Ope7ujtVR/RNdm+YUOwoW0m0Z
 Rl9nPAm55X+dKpApsl8KS6hQjtU+ovrzklQ02yoqsRlUaSSSmKXWz9tj6/28Jbzl/3ostYN
 SkYlrAFNl8nBJhkYeUYo7EyLb4bInkphhHf2SnbEvxLY2eZ9Nn/+nWiqNyMFOpYRxQAmzmz
 paPtcEsexj6xY1oPMWICQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 December 2014 14:06:51 Kevin Cernekee wrote:
> V4->V5:
> 
>  - Rebase on top of Linus' head of tree, converting BCM3384 platform code
>    to Generic BMIPS platform code.
> 
>  - Fix a couple of #include's
> 
>  - Remove a couple of bogus entries from bmips_be_defconfig
> 
> Compile-tested only.  Some BMIPS platforms may require acked-but-unmerged
> changes in other subsystems (like the native-endian serial8250/DT patches).
> 
> For 3.19 you'll want the first patch at the minimum (because the build is
> currently broken).
> 

Since I commented on some of these patches before, I now took another
(not very thorough) look at all of them. Looks very nice overall, I
have no further comments.

Acked-by: Arnd Bergmann <arnd@arndb.de>
