Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960AbaACM7S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 07:59:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57841 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022AbaACM7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 07:59:17 -0500
Message-ID: <52C6D0DB.1050906@suse.de>
Date: Fri, 03 Jan 2014 16:01:47 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: status of block-integrity
References: <20131222192128.GA28532@infradead.org>
In-Reply-To: <20131222192128.GA28532@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2013 08:21 PM, Christoph Hellwig wrote:
> We have the block integrity code to support DIF/DIX in the the tree for
> about 5 and a half years, and we still don't have a single consumer of
> it.  By normal kernel rules it should never have been merged, or at
> least the bitrot long removed.
>
> Given that we'll have a lot of work to do in this area with block
> multiqueue I think it's time to either kill it off for good or make sure
> we can actually use and test it.

Which would make an ideal topic for LSF, wouldn't it?

Personally, I doubt it's a good idea to kill it off, but
a proper (userland) API for it has been a long time missing.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
