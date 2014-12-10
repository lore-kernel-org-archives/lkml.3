Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373AbaLJLDy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 06:03:54 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:64424 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbaLJLDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 06:03:53 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Weinberger <richard@nod.at>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Ley Foon Tan <lftan@altera.com>,
        linux-kernel@vger.kernel.org, Daniel Walter <sahne@0x90.at>,
        user-mode-linux-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [BUG] uml panics with "Segfault with no mm" in v3.19-rc
Date: Wed, 10 Dec 2014 12:03:37 +0100
Message-ID: <2739506.ACK9B2Kt4q@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54882533.6080901@nod.at>
References: <20141210104624.GB32280@tucsk.suse.de> <54882533.6080901@nod.at>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:AfkwITXGMao/FR8aKmPGmKTFvK6kse282jwrXdvbGZ/3MsCE+Bo
 GhZCpO8Vh3Xo5m5eWUTz+OKrNLCsN1AIGYfnbDa5NAmTn5Go+HVqiPiL2puRF1EbyJf/XxF
 6UpYfNavb7tCARo+nO/3GpOeWQ8eeZwv8LPEprdXv03WLeFh1Ws76iO1ZkjwvAyK//2MJ48
 tUAWViUodHL4DRSbtvPlw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 December 2014 11:49:23 Richard Weinberger wrote:
> Hi!
> 
> Am 10.12.2014 um 11:46 schrieb Miklos Szeredi:
> > The guilty commit is:
> > 
> >   00f634bc522d "asm-generic: add generic futex for !CONFIG_SMP"
> 
> Thanks a lot Miklos!
> Your bisecting faster than I do.
> 
> Let's dig into the issue!
> 

Did this happen on linux-next as well?

Does this happen only on non-SMP UML running on an SMP host, or also
in other combinations?

	Arnd
