Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab3KAQDK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 12:03:10 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54414 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402Ab3KAQDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 12:03:09 -0400
Message-ID: <5273D0B1.2030006@kernel.dk>
Date: Fri, 01 Nov 2013 10:02:57 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>
CC: Kent Overstreet <kmo@daterainc.com>, linux-kernel@vger.kernel.org
Subject: Re: stec skd block driver needs updating for immutable biovec
References: <20131101135931.GA22903@redhat.com> <5273C2B8.5030608@kernel.dk> <20131101154338.GA23501@redhat.com> <20131101155027.GA5665@infradead.org>
In-Reply-To: <20131101155027.GA5665@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2013 09:50 AM, Christoph Hellwig wrote:
> On Fri, Nov 01, 2013 at 11:43:39AM -0400, Mike Snitzer wrote:
>> All the bi_sector ones are low hanging fruit, but the conversion for
>> skd_preop_sg_list_bio()'s bio_vec code is more involved.
>>
>> Kent, any chance you could crank through it?
>>
>> If not I can come back to trying to fix this later.. but I'm working
>> through a test merge of linux-dm.git's 'for-next' with linux-block.git's
>> 'for-next'.
> 
> The right thing for 3.13 is to rip out the bio base code path, and
> for 3.14 to convert it to blk-mq.

It is. I will kill it.

-- 
Jens Axboe

