Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbaCNLKE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 07:10:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57275 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752995AbaCNLKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 07:10:03 -0400
Message-ID: <5322E388.6090809@suse.de>
Date: Fri, 14 Mar 2014 12:10:00 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Mike Snitzer <snitzer@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Shaohua Li <shli@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] block: rework flush sequencing for blk-mq
References: <20140130132630.GB6031@infradead.org> <x49iorp3fhm.fsf@segfault.boston.devel.redhat.com> <20140308155240.GA32297@infradead.org> <CAMM=eLewbtK7LiNZCXo=hm-sjVU2+MN+xTFuxb89mDA1iS3r0w@mail.gmail.com> <531B74B6.4070004@suse.de> <20140312102849.GA26509@infradead.org> <20140313161347.GA6598@redhat.com> <20140314092519.GA10139@infradead.org> <20140314093458.GA19451@infradead.org> <5322D177.8050408@suse.de> <20140314105854.GA4077@infradead.org>
In-Reply-To: <20140314105854.GA4077@infradead.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2014 11:58 AM, Christoph Hellwig wrote:
> On Fri, Mar 14, 2014 at 10:52:55AM +0100, Hannes Reinecke wrote:
>> No, I haven't. This issue is only exhibited if you try to run
>> multipath on a non-SCSI device (in this case it was cciss).
>> But then that project got abandoned, and there never was a machine
>> with a multipathed cciss controller.
> 
> We still shouldn't be able to easily crash the kernel because someone
> configured the wrong device.  And with scsi-mq that wrong devices case
> might become a lot more common..
> 
Ok, will be resending.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
