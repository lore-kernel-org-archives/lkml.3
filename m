Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbaETCAn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 22:00:43 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:34525 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbaETCAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 22:00:41 -0400
Message-ID: <537AB746.5040702@kernel.dk>
Date: Mon, 19 May 2014 20:00:38 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>
CC: Christoph Hellwig <hch@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: time to move fs/bio.c to block/ ?
References: <20140519141309.GB21570@infradead.org>	<537A11CC.5060708@kernel.dk> <CACVXFVNP=krc7juPwSpSSFwvsu4aifST5OUfpc4V7QE4nmm_2A@mail.gmail.com>
In-Reply-To: <CACVXFVNP=krc7juPwSpSSFwvsu4aifST5OUfpc4V7QE4nmm_2A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-05-19 18:28, Ming Lei wrote:
> On Mon, May 19, 2014 at 10:14 PM, Jens Axboe <axboe@kernel.dk> wrote:
>> On 05/19/2014 08:13 AM, Christoph Hellwig wrote:
>>> I recently saw patches to fs/bio.c that were sent to Al instead of Jens.
>>> I think having bio.c in fs/ is rather confusing, so maybe it's time to
>>> include the simple git-mv for it in the your for-next tree?
>>
>> Sure, I've been thinking that too for a while. I'll do the move.
>
> mm/bounce.c is another one.

True, that should be moved as well.

-- 
Jens Axboe

