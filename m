Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbaFDOy2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 10:54:28 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:35834 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbaFDOy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 10:54:26 -0400
Message-ID: <538F331F.60101@kernel.dk>
Date: Wed, 04 Jun 2014 08:54:23 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch]blk-mq: blk_mq_tag_to_rq should handle flush request
References: <20140509120733.GA27918@kernel.org> <20140509150018.GA26215@infradead.org> <20140510040023.GA13788@kernel.org> <5388912F.7010609@kernel.dk> <20140604111133.GA7826@infradead.org> <538F2A11.4060800@kernel.dk> <20140604142012.GA20056@infradead.org>
In-Reply-To: <20140604142012.GA20056@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-06-04 08:20, Christoph Hellwig wrote:
> On Wed, Jun 04, 2014 at 08:15:45AM -0600, Jens Axboe wrote:
>> Alright, I'll revert it to pass in the tags instead.
>
> It's not as simple as the added code wants to get a queue from the
> hwctx, which we can't get at.  I was planning to look into this, but
> there are various other regressions in the recent block updates that I
> need to fix before I can even test a tree with this one reverted.

Which regressions? Performance or crashes?

> If you can get to sorting this out soon I'd love you to handle it,
> otherwise I'll look into it as soon as I can.

Just took a look at it, but I don't see the problematic path. I'm 
looking at wip-9.

-- 
Jens Axboe

