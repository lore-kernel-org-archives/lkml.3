Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933592AbaFRDMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 23:12:22 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:35123 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932489AbaFRDMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 23:12:21 -0400
Message-ID: <53A10394.3010701@kernel.dk>
Date: Tue, 17 Jun 2014 20:12:20 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alexander Gordeev <agordeev@redhat.com>
CC: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 0/3] blk-mq: bitmap tag: Fix few races
References: <cover.1402582256.git.agordeev@redhat.com> <20140617103531.GA13924@infradead.org> <53A040CF.2000105@kernel.dk> <20140617173956.GB361@dhcp-26-207.brq.redhat.com>
In-Reply-To: <20140617173956.GB361@dhcp-26-207.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-06-17 10:39, Alexander Gordeev wrote:
> On Tue, Jun 17, 2014 at 07:21:19AM -0600, Jens Axboe wrote:
>> On 2014-06-17 04:35, Christoph Hellwig wrote:
>>> Jens, did you plan to pick these up?  There's a few bits of low hanging
>>> fruit for cleanups / micro-optimizations in this area, but I don't want
>>> to create conflicts with Alexanders work.
>>
>> I'm evaluating just getting rid of the cyclic waits, which is why
>> I've held off. But the patches don't apply to the current tree
>> anyway, so they would need a rediffing no matter what.
>
> Hi Jens,
>
> Patches 1/3 and 2/3 apply to Linus's tree and could go in without patch 3/3.
> I'll post v2 of 3/3.

As mentioned in another thread, I'm sort-of hoping we can just get rid 
of the nasty multiple waitqueues. Will run some testing when I'm back. 
If we still see a nice gain of having the cycling waitqueues, then I'll 
test and apply your patches to close up the holes.


-- 
Jens Axboe

