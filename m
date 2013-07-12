Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469Ab3GLB2b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 21:28:31 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:46455 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab3GLB2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 21:28:30 -0400
Message-ID: <1373592815.7397.477.camel@haakon3.risingtidesystems.com>
Subject: Re: [Ksummit-2013-discuss] [ATTEND] scsi-mq prototype discussion
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Greg KH <greg@kroah.com>
Cc: ksummit-2013-discuss@lists.linuxfoundation.org,
        Jens Axboe <axboe@kernel.dk>, James Smart <James.Smart@Emulex.Com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        James Bottomley <jbottomley@parallels.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>, kmo@daterainc.com,
        target-devel <target-devel@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>, Tejun Heo <tj@kernel.org>,
        Christoph Hellwig <hch@lst.de>, scameron@beardog.cce.hp.com
Date: Thu, 11 Jul 2013 18:33:35 -0700
In-Reply-To: <20130712010223.GA15673@kroah.com>
References: <1373588612.7397.447.camel@haakon3.risingtidesystems.com>
	 <20130712010223.GA15673@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-11 at 18:02 -0700, Greg KH wrote:
> On Thu, Jul 11, 2013 at 05:23:32PM -0700, Nicholas A. Bellinger wrote:
> > Drilling down the work items ahead of a real mainline push is high on
> > priority list for discussion.
> > 
> > The parties to be included in such a discussion are:
> > 
> >   - Jens Axboe (blk-mq author)
> >   - James Bottomley (scsi maintainer)
> >   - Christoph Hellwig (scsi)
> >   - Martin Petersen (scsi)
> >   - Tejun Heo (block + libata)
> >   - Hannes Reinecke (scsi error recovery)
> >   - Kent Overstreet (block, per-cpu ida)
> >   - Stephen Cameron (scsi-over-pcie driver)
> >   - Andrew Vasquez (qla2xxx LLD)
> >   - James Smart (lpfc LLD)
> 
> Isn't this something that should have been discussed at the storage
> mini-summit a few months ago?

The scsi-mq prototype, along with blk-mq (in it's current form) did not
exist a few short months ago.  ;)

>  It seems very specific to one subsystem to be a kernel summit topic,
> don't you think?

It's no more subsystem specific than half of the other proposals so far,
and given it's reach across multiple subsystems (block, scsi, target),
and the amount of off-list interest on the topic, I think it would make
a good candidate for discussion.

Thanks,

--nab 

