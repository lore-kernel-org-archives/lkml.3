Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbaLCKyK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 05:54:10 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:63301 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaLCKyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 05:54:08 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Stefan Agner <stefan@agner.ch>, shawn.guo@linaro.org,
        kernel@pengutronix.de, linux@arm.linux.org.uk,
        u.kleine-koenig@pengutronix.de, jason@lakedaemon.net, olof@lixom.net,
        daniel.lezcano@linaro.org, tglx@linutronix.de, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/12] ARM: unify MMU/!MMU addruart calls
Date: Wed, 03 Dec 2014 11:53:31 +0100
Message-ID: <2260991.G6QM1xu48B@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1417565531-4507-10-git-send-email-stefan@agner.ch>
References: <1417565531-4507-1-git-send-email-stefan@agner.ch> <1417565531-4507-10-git-send-email-stefan@agner.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Y0EEABdcc8ngtk42M1DDA+J7voWGOdq6cd8HdtGaCWO
 oDC0xEGirWkzRtRZaOjztqOva+9/ZzniNKyMPtk+9P91KH1jeF
 oJfncLrvfY+7Qi2LKXY/I6A7seD+4IYi1NezcPr/l2n+kr1wBK
 4rmv9rWpVFh1SXJxI2GZ0+bRseHg0KtsOocYFHwaX5J48RLF2x
 NZdA5yZmw00B4vR9NvnHsvOmSLFY6b2LsxUTzRLNQubuTWBsrB
 ClVkdqqJDpImuIeUtdti0P78yTnE5MRUDWSayTw6gQbkHlbhV9
 GDMGCW4p1XfuIE3RoBR31cx4MiSJ/FDMT2/6fd5TxKf7aO3KdC
 fvsUE9cvtB1GpdInh0qg=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 December 2014 01:12:08 Stefan Agner wrote:
> Remove the needless differences between MMU/!MMU addruart calls.
> This allows to use the same addruart macro on SoC level. Useful
> for SoC consisting of multiple CPUs with and without MMU such as
> Freescale Vybrid.
> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> 

I think I had the same patch somewhere hidden in my collection
of stuff I need to submit one day. Looks good.

	Arnd
