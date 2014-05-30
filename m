Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933689AbaE3PMY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 11:12:24 -0400
Received: from zougloub.eu ([198.27.83.45]:55546 "EHLO zougloub.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933669AbaE3PMV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 11:12:21 -0400
Date: Fri, 30 May 2014 11:14:00 -0400
From: =?UTF-8?B?SsOpcsO0bWU=?= Carretero <cJ-ko@zougloub.eu>
To: Roger Heflin <rogerheflin@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-ide <linux-ide@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: Bad DMA from Marvell 9230
Message-ID: <20140530111400.5d7292ab@Vantage>
In-Reply-To: <CAAMCDecAgn=FX4Lw4YK_z4OKZsKqaj3scXe2cg0HN9tSj_FokA@mail.gmail.com>
References: <1395903457.5569.89.camel@pasglop>
	<20140530030618.5ad4f447@Vantage>
	<1401446278.14938.26.camel@pasglop>
	<20140530095822.3588a6ff@Vantage>
	<CAAMCDecAgn=FX4Lw4YK_z4OKZsKqaj3scXe2cg0HN9tSj_FokA@mail.gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 May 2014 09:13:43 -0500
Roger Heflin <rogerheflin@gmail.com> wrote:

> I had a 9230...
> [...]
> Supplier support "claimed" it to be a Linux AHCI bug as the "claim"
> that their board correctly supports AHCI, even though all other AHCI
> boards work right in this exact same use case in the exact same
> machine.

Does somebody know about another supplier that provides equivalent
SATA adapters that behave well, are robust and support FIS switching,
and don't come with proprietary drivers/utilities but rather *support*
their linux driver?

I'd bite the bullet and get a better, more expensive device, but it
doesn't seem to come with appropriate software support either.

There are some RAID adapters that don't expose the disks if we're
not creating RAID volumes... with an ugly CLI, and where we don't know
what's written where on the disk in case we are to create one volume
per disk, and do software RAID later.
Not tempted to use that.

Or waste PCIe slots and use more el-cheapo ASMedia 1061 PCIe-1x
devices... do these work well?

-- 
Jérôme
