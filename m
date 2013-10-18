Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615Ab3JRQzT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 12:55:19 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54351 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756529Ab3JRQzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 12:55:17 -0400
Message-ID: <526167ED.1010503@kernel.dk>
Date: Fri, 18 Oct 2013 10:55:09 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: LKML-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] remove cpqarray from mainline kernel
References: <20131017175226.GA31535@thumper.usa.hp.com> <20131017141337.425f84c630ffe1c7c61c4dc4@linux-foundation.org> <20131017223616.GB32575@kernel.dk> <48275AD710FCA34184C2B6186B4016B32D15F735@G6W2491.americas.hpqcorp.net>
In-Reply-To: <48275AD710FCA34184C2B6186B4016B32D15F735@G6W2491.americas.hpqcorp.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2013 10:22 AM, Miller, Mike (OS Dev) wrote:
> 
> 
>> -----Original Message-----
>> From: Jens Axboe [mailto:axboe@kernel.dk]
>> Sent: Thursday, October 17, 2013 5:36 PM
>> To: Andrew Morton
>> Cc: Miller, Mike (OS Dev); LKML-scsi; LKML
>> Subject: Re: [PATCH 1/1] remove cpqarray from mainline kernel
>>
>> On Thu, Oct 17 2013, Andrew Morton wrote:
>>> On Thu, 17 Oct 2013 12:52:26 -0500 Mike Miller <mike.miller@hp.com>
>> wrote:
>>>
>>>> cpqarray hasn't been used in over 12 years. It's doubtful that
>>>> anyone still uses the board. It's time the driver was removed from the
>> mainline kernel.
>>>> The only updates these days are minor and mostly done by people
>> outside of HP.
>>>
>>> It's amazing the weird stuff people get up to.  Perhaps we should
>>> disable it in config for a cycle or two, see if that flushes anyone out?
>>
>> I think that would be prudent, you never know what people run...
>>
>> --
>> Jens Axboe
> 
> I agree with Andrew's suggestion. Should I submit a patch that only removes cpqarray from config?

I put one in yesterday:

http://git.kernel.dk/?p=linux-block.git;a=commit;h=f504954db0ecccaded5397e3432cdaf7175602fb

-- 
Jens Axboe

