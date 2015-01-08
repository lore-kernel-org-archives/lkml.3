Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628AbbAHWqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 17:46:52 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:56750 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757380AbbAHWqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 17:46:51 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Baruch Siach <baruch@tkos.co.il>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 0/8] ARM: Conexant Digicolor CX92755 SoC support
Date: Thu, 08 Jan 2015 23:46:46 +0100
Message-ID: <5966468.GiJYdzCvnt@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <cover.1420744368.git.baruch@tkos.co.il>
References: <cover.1420744368.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:hQM12wnorMku5WyOhKFeIMoe9vNmo0ymDV5hAMdwO4fL0+uA/MS
 O/6HZr+HTaJEvR3xAbpLSyA5VP0Yccz4wsCmEnPjHSjGHWd7XwflGqgjWfXaNNwNEaIhg47
 ZmD4+p50Lu54MpG13VWTmjegnwd6Xp84UMbxtjnEHf8uxmjIgNWhpUfSQdNSa5DYvB1Lqzk
 PdRJcbAvAMi6fT0csI+AA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 January 2015 21:39:56 Baruch Siach wrote:
> This series adds initial support for the Conexant CX92755 SoC. The CX92755 is
> one of the Digicolor series of SoCs, all sharing many of the same peripherals.
> The code was tested on the CX92755 evaluation kit, AKA Equinox.
> 
> Uses attempting to try this code will most likely also want the UART/console
> driver available from https://patchwork.kernel.org/patch/5515861/.
 
Looks great overall now.

I have just two more comments in one patch, and one general request:

Please add a patch description for every patch. The text above would
be a good start for the first patch, but it would be lost in the git
history if it's only in the cover letter.

other than that, feel free to add my

Acked-by: Arnd Bergmann <arnd@arndb.de>

Once there are no more review comments, please submit the first three
patches to arm@kernel.org, and send the other patches as separate
series to the respective maintainers for irqchip and clocksource.

	Arnd
