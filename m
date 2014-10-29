Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560AbaJ2H35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 03:29:57 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:62799 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbaJ2H34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 03:29:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: f.fainelli@gmail.com, tglx@linutronix.de, jason@lakedaemon.net,
        ralf@linux-mips.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, mbizon@freebox.fr, jogo@openwrt.org,
        linux-mips@linux-mips.org
Subject: Re: [PATCH 02/11] irqchip: brcmstb-l2: Eliminate dependency on ARM code
Date: Wed, 29 Oct 2014 08:29:33 +0100
Message-ID: <4427811.Si9a9OX0zn@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1414555138-6500-2-git-send-email-cernekee@gmail.com>
References: <1414555138-6500-1-git-send-email-cernekee@gmail.com> <1414555138-6500-2-git-send-email-cernekee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:djXYKn5dpSWTWMIsfZD4hl4YtxeMiPM8m3/hiWj1pAS
 4QF2nbHf3XRUDf/GXtHVEbH0mk+rObN3qvb4omhEWToQJolQ27
 XAzHrpHkCFA9RNxX6vtuA69tuv3xpebNXgzcItxIPhq5CgafPs
 YJ1N3aHtO0YcInJOqRc4pvsBYt3U35oXqKUdpk5iVJCfl8MFcs
 LfaYZdtfw24VH707LsKTHhs3Zh+BLzs9v7qSkeg4ZHqOI1Cwvx
 /9wLGMCOKLvoZX9N41+JgCp3guf2mi4SdzSuXcLMfq80sxLmpN
 +IdFm9dFVLpKQcAR7f2f5o7XEJTrNcReSPhKf6ukauSgQR4qR/
 2TbjArYcM8OfZiGATFnM=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 October 2014 20:58:49 Kevin Cernekee wrote:
> The irq-brcmstb-l2 driver has a single dependency on the ARM code, the
> do_bad_IRQ macro.  Expand this macro in-place so that the driver can be
> built on non-ARM platforms.
> 
> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>
