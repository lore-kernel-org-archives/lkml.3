Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025Ab3HLPUk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 11:20:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755720Ab3HLPUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 11:20:38 -0400
Date: Mon, 12 Aug 2013 17:21:39 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Mike Christie <michaelc@cs.wisc.edu>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
Message-ID: <20130812152138.GA10739@dhcp-26-207.brq.redhat.com>
References: <1374790082.7397.1411.camel@haakon3.risingtidesystems.com>
 <20130726020928.GL29296@kernel.dk>
 <1374873276.7397.1512.camel@haakon3.risingtidesystems.com>
 <20130729114653.GB20951@mtj.dyndns.org>
 <20130809082335.GA25306@dhcp-26-207.brq.redhat.com>
 <5204FBA6.6040001@kernel.dk>
 <20130809150744.GB25306@dhcp-26-207.brq.redhat.com>
 <52051033.8050605@kernel.dk>
 <20130809164632.GC25306@dhcp-26-207.brq.redhat.com>
 <520521D9.3040104@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520521D9.3040104@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 11:07:37AM -0600, Jens Axboe wrote:
> You don't have to resubmit, I'll get it reviewed and applied today.

Hi Jens,

I limited the minimal queue depth to 4, which is apparently wrong
in case of libata. I will post a new series.

> -- 
> Jens Axboe
> 

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
