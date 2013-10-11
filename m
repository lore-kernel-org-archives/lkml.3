Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251Ab3JKOYe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 10:24:34 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39161 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab3JKOYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 10:24:33 -0400
Message-ID: <525809E0.10403@kernel.dk>
Date: Fri, 11 Oct 2013 08:23:28 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>, Alexander Gordeev <agordeev@redhat.com>
CC: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        target-devel <target-devel@vger.kernel.org>
Subject: Re: scsi-mq updated to latest linux-block/new-queue
References: <1381345971.19256.461.camel@haakon3.risingtidesystems.com> <20131009194658.GA3066@dhcp-26-207.brq.redhat.com> <20131010191714.GA3098@lst.de> <20131010193240.GA17206@dhcp-26-207.brq.redhat.com> <20131011121932.GA18146@lst.de>
In-Reply-To: <20131011121932.GA18146@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2013 06:19 AM, Christoph Hellwig wrote:
> On Thu, Oct 10, 2013 at 09:32:41PM +0200, Alexander Gordeev wrote:
>> I wonder, if blk-mq- prefix should remain?.. This s code seems pretty much
>> generic to me.
> 
> Seems like nowdays you should just use the percpu-ida allocator directly,
> Shaohua Li hast just sent patches to switch blk-mq over to it as well.

Yeah, that was on the list of things to do and then test.


-- 
Jens Axboe

