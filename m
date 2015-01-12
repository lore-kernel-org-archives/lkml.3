Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612AbbALUgt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 15:36:49 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:48239 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbbALUgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 15:36:47 -0500
From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
To: Suman Tripathi <stripathi@apm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: SATA link power management issues
Date: Mon, 12 Jan 2015 21:36:44 +0100
Message-ID: <83596004.97VzmK2jef@xps13>
In-Reply-To: <CAOHikRCp=m6tgKEmdg2pLj=XB2ugCGhj0rkeqCzF2+DPR8O9sw@mail.gmail.com>
References: <3352987.ugV1Ipy7Z5@xps13> <8996449.0OJMDi8J8q@xps13> <CAOHikRCp=m6tgKEmdg2pLj=XB2ugCGhj0rkeqCzF2+DPR8O9sw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 January 2015 02:00:45 Suman Tripathi wrote:
> On Monday 12 January 2015 22:46:02 Suman Tripathi wrote:
> > Can you dump the ata_id parameters(LPM section) from the drive and we
> > can check the related LPM parameters of the drive ?
> 
> Hi,
> 
> I'm sorry, but I'm not really familiar with ata, could you be a bit
> more specific about what you'd like to see?
> ok no issues. First can show the log from the point the drive got
> enumerated ? Like for eg :
> ata2.00: ATA-8: WDC WD5000AAKX-08U6AA0, 19.01H19, max UDMA/100
> 
> ata2.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 0/32)
> 
> ata2.00: configured for UDMA/100
> 
> I would like to the ATA version the drive is complaint. In the above case
> it is ATA-8

[    0.698842] ata3: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    0.701419] ata3.00: ATA-8: LITEONIT LMT-256M6M mSATA 256GB, DM8110F, max UDMA/133
[    0.701421] ata3.00: 500118192 sectors, multi 1: LBA48 NCQ (depth 31/32), AA
[    0.701982] ata3.00: configured for UDMA/133

You can see the entire log here:
http://www.spinics.net/lists/linux-ide/msg50069.html

> 
> Thanks,
> Gabriele
> 
> On Tue, Jan 13, 2015 at 1:56 AM, Gabriele Mazzotta <gabriele.mzt@gmail.com>
> wrote:
> 
> > On Monday 12 January 2015 22:46:02 Suman Tripathi wrote:
> > > Can you dump the ata_id parameters(LPM section) from the drive and we
> > > can check the related LPM parameters of the drive ?
> >
> > Hi,
> >
> > I'm sorry, but I'm not really familiar with ata, could you be a bit
> > more specific about what you'd like to see?
> >
> > Thanks,
> > Gabriele
> >
