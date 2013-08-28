Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470Ab3H1Pym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 11:54:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24002 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753176Ab3H1Pyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 11:54:40 -0400
Date: Wed, 28 Aug 2013 17:56:21 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Mike Christie <mchristie@fusionio.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        Jeff Garzik <jgarzik@pobox.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
Message-ID: <20130828155620.GA7026@dhcp-26-207.brq.redhat.com>
References: <1374195825.7397.997.camel@haakon3.risingtidesystems.com>
 <1374215660.7397.1041.camel@haakon3.risingtidesystems.com>
 <1374248000.2266.20.camel@dabdike>
 <1374267684.7397.1058.camel@haakon3.risingtidesystems.com>
 <1374296162.7397.1098.camel@haakon3.risingtidesystems.com>
 <51EAA33C.9010405@fusionio.com>
 <20130809191542.GD25306@dhcp-26-207.brq.redhat.com>
 <1376079457.5171.172.camel@haakon3.risingtidesystems.com>
 <20130815162316.GA27882@dhcp-26-207.brq.redhat.com>
 <1376619569.5171.217.camel@haakon3.risingtidesystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376619569.5171.217.camel@haakon3.risingtidesystems.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 07:19:29PM -0700, Nicholas A. Bellinger wrote:
> Anyways, before digging further into reserved tags logic, Jens, what are
> your thoughts for addressing this special queue_depth=1 case for libata
> + the like..?

Hi Jens,

Have some comments?

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
