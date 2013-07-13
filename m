Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab3GMGxn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 02:53:43 -0400
Received: from mx2.parallels.com ([199.115.105.18]:42671 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab3GMGxl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 02:53:41 -0400
From: James Bottomley <jbottomley@parallels.com>
To: Hannes Reinecke <hare@suse.de>
CC: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Jens Axboe <axboe@kernel.dk>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        James Smart <James.Smart@Emulex.Com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "kmo@daterainc.com" <kmo@daterainc.com>,
        target-devel <target-devel@vger.kernel.org>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>, Tejun Heo <tj@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        "scameron@beardog.cce.hp.com" <scameron@beardog.cce.hp.com>
Subject: Re: [Ksummit-2013-discuss] [ATTEND] scsi-mq prototype discussion
Thread-Topic: [Ksummit-2013-discuss] [ATTEND] scsi-mq prototype discussion
Thread-Index: AQHOfpVv2TksF95TD0G0h7C4mQqWyZlgrxyAgAAIuICAAJwxgIABT4YA
Date: Sat, 13 Jul 2013 06:53:32 +0000
Message-ID: <1373698410.2922.10.camel@dabdike>
References: <1373588612.7397.447.camel@haakon3.risingtidesystems.com>
	 <20130712010223.GA15673@kroah.com>
	 <1373592815.7397.477.camel@haakon3.risingtidesystems.com>
	 <51DFDFF5.80702@suse.de>
In-Reply-To: <51DFDFF5.80702@suse.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [194.186.187.194]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <E181B1EA86CD704B8CD424D82E41E669@sw.swsoft.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-12 at 12:52 +0200, Hannes Reinecke wrote:
> On 07/12/2013 03:33 AM, Nicholas A. Bellinger wrote:
> > On Thu, 2013-07-11 at 18:02 -0700, Greg KH wrote:
> >> On Thu, Jul 11, 2013 at 05:23:32PM -0700, Nicholas A. Bellinger wrote:
> >>> Drilling down the work items ahead of a real mainline push is high on
> >>> priority list for discussion.
> >>>
> >>> The parties to be included in such a discussion are:
> >>>
> >>>   - Jens Axboe (blk-mq author)
> >>>   - James Bottomley (scsi maintainer)
> >>>   - Christoph Hellwig (scsi)
> >>>   - Martin Petersen (scsi)
> >>>   - Tejun Heo (block + libata)
> >>>   - Hannes Reinecke (scsi error recovery)
> >>>   - Kent Overstreet (block, per-cpu ida)
> >>>   - Stephen Cameron (scsi-over-pcie driver)
> >>>   - Andrew Vasquez (qla2xxx LLD)
> >>>   - James Smart (lpfc LLD)
> >>
> >> Isn't this something that should have been discussed at the storage
> >> mini-summit a few months ago?
> > 
> > The scsi-mq prototype, along with blk-mq (in it's current form) did not
> > exist a few short months ago.  ;)
> > 
> >>  It seems very specific to one subsystem to be a kernel summit topic,
> >> don't you think?
> > 
> > It's no more subsystem specific than half of the other proposals so far,
> > and given it's reach across multiple subsystems (block, scsi, target),
> > and the amount of off-list interest on the topic, I think it would make
> > a good candidate for discussion.
> > 
> And it'll open up new approaches which previously were dismissed,
> like re-implementing multipathing on top of scsi-mq, giving us the
> single scsi device like other UNIX systems.
> 
> Also I do think there's quite some synergy to be had, as with blk-mq
> we could nail each queue to a processor, which would eliminate the
> need for locking.
> Which could be useful for other subsystems, too.

Lets start with discussing this on the list, please, and then see where
we go from there ...

James

