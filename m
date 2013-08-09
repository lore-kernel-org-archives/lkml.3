Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030296Ab3HIOPJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 10:15:09 -0400
Received: from mail-qe0-f51.google.com ([209.85.128.51]:62349 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967879Ab3HIOPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 10:15:07 -0400
Date: Fri, 9 Aug 2013 10:15:00 -0400
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Jens Axboe <axboe@kernel.dk>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Mike Christie <michaelc@cs.wisc.edu>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
Message-ID: <20130809141500.GF20515@mtj.dyndns.org>
References: <1374267684.7397.1058.camel@haakon3.risingtidesystems.com>
 <1374296162.7397.1098.camel@haakon3.risingtidesystems.com>
 <20130722150359.GA16564@dhcp-26-207.brq.redhat.com>
 <1374527436.7397.1145.camel@haakon3.risingtidesystems.com>
 <20130725101641.GB31994@dhcp-26-207.brq.redhat.com>
 <1374790082.7397.1411.camel@haakon3.risingtidesystems.com>
 <20130726020928.GL29296@kernel.dk>
 <1374873276.7397.1512.camel@haakon3.risingtidesystems.com>
 <20130729114653.GB20951@mtj.dyndns.org>
 <20130809082335.GA25306@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130809082335.GA25306@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 10:23:35AM +0200, Alexander Gordeev wrote:
> On Mon, Jul 29, 2013 at 07:46:53AM -0400, Tejun Heo wrote:
> > One thing which would probably be worthwhile tho is getting rid of the
> > bitmap based qc tag allocator in libata.  That one is just borderline
> > stupid to keep around on any setup which is supposed to be scalable.
> 
> Hi Tejun,
> 
> How about this approach?

Haven't looked at it thoroughly and I still don't know anything about
blk-mq but it looks good on the first glance.

Thanks.

-- 
tejun
