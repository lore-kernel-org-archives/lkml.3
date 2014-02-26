Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbaBZVLL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 16:11:11 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:60031 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135AbaBZVLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 16:11:08 -0500
Message-ID: <530E5859.1080303@kernel.dk>
Date: Wed, 26 Feb 2014 13:10:49 -0800
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, Sam Bradshaw <sbradshaw@micron.com>,
        Asai Thambi S P <asamymuthupa@micron.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: mtip32xx blk-mq status?
References: <20140226192945.GA26603@infradead.org>
In-Reply-To: <20140226192945.GA26603@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-02-26 11:29, Christoph Hellwig wrote:
> Hi all,
>
> with blk-mq stabilizing in mainline and Jens using mtip32xx as tje major
> example drivers in the past is there any progress on getting the
> conversion finished and merged?

I'll pick up the pieces as soon as I get back and can test again. The 
basic conversion is easy enough, I'll just dust that off. On top of that 
I started splitting the issue groups up, since it actually gets you a 
good step further than just the basic conversion.

The only problem area I ran into was the special case of the unaligned 
writes.

-- 
Jens Axboe


