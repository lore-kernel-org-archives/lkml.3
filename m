Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101AbaHKS5L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 14:57:11 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:63259 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527AbaHKS5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 14:57:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 2/2] asm-generic: add memfd_create system call to unistd.h
Date: Mon, 11 Aug 2014 20:57:00 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: David Herrmann <dh.herrmann@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
References: <1407764228-7904-1-git-send-email-will.deacon@arm.com> <CANq1E4Q0gDaJ5XGnkoCQsG8xLh1Q-EBErtEVPpeeZgGj+Nr8dQ@mail.gmail.com> <20140811171511.GF8828@arm.com>
In-Reply-To: <20140811171511.GF8828@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201408112057.01177.arnd@arndb.de>
X-Provags-ID: V02:K0:3TtRjQxwWmXpaB76hIbqYstei7xVr50fNr2aTc4wpmv
 A8bSttzm7uJ0UWFrtA8DojhD85Ple2X8c+2KRs+TEFtQDtMsiX
 mYpVm+ZW5a5SOxadEkl2o/2ebxzvPaRuLUuiuzfMtPx9/uQjJI
 eneOPOstZJY8lOB1jwz6kgp72DykdhhD8V0fjYzFgesxqxteVD
 FR9nptx/S/Su3q58lMH0WlsPqtKwz1t/PnTTVsOGXrPWg8LMWu
 w54AYVToXBcFuzOOinCbz7i8ZGvdKKcPqnZ9V3WSbMaqjlH3r7
 tH32w9uniGFVGF8HL+GzD5AL7xS3wZCqvV/2Ud0HHqdQcq3lI2
 JoUFwC/6+y7b3t7Bd0nmjhOqwPDDSr9aqpnfhZKvJ
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 August 2014, Will Deacon wrote:
> On Mon, Aug 11, 2014 at 05:54:08PM +0100, David Herrmann wrote:
> > On Mon, Aug 11, 2014 at 3:37 PM, Will Deacon <will.deacon@arm.com> wrote:
> > > Commit 9183df25fe7b ("shm: add memfd_create() syscall") added a new
> > > system call (memfd_create) but didn't update the asm-generic unistd
> > > header.
> > >
> > > This patch adds the new system call to the asm-generic version of
> > > unistd.h so that it can be used by architectures such as arm64.
> > >
> > > Cc: Arnd Bergmann <arnd@arndb.de>
> > > Cc: David Herrmann <dh.herrmann@gmail.com>
> > > Signed-off-by: Will Deacon <will.deacon@arm.com>
> > 
> > Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
> 
> Thanks, David.
> 
> Arnd: shall I take this via the arm64 tree, or do you already have some
> asm-generic patches queued?

Please take it for arm64, I don't have any other patches queued at the moment
and am currently on vacation.

	Arnd
