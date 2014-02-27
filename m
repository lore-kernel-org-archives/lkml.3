Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452AbaB0FHN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 00:07:13 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:58025 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbaB0FHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 00:07:11 -0500
Message-ID: <530EC7FB.3070204@kernel.dk>
Date: Wed, 26 Feb 2014 21:07:07 -0800
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Asai Thambi Samymuthu Pattrayasamy (asamymuthupa)" 
	<asamymuthupa@micron.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: mtip32xx blk-mq status?
References: <20140226192945.GA26603@infradead.org> <530E5859.1080303@kernel.dk> <80B89753B40C5141A3E2D53FE7A2A8A982C86A74@NTXBOIMBX02.micron.com>
In-Reply-To: <80B89753B40C5141A3E2D53FE7A2A8A982C86A74@NTXBOIMBX02.micron.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-02-26 20:42, Sam Bradshaw (sbradshaw) wrote:
>
>> On 2014-02-26 11:29, Christoph Hellwig wrote:
>>> Hi all,
>>>
>>> with blk-mq stabilizing in mainline and Jens using mtip32xx as tje
>> major
>>> example drivers in the past is there any progress on getting the
>>> conversion finished and merged?
>>
>> I'll pick up the pieces as soon as I get back and can test again. The
>> basic conversion is easy enough, I'll just dust that off. On top of
>> that
>> I started splitting the issue groups up, since it actually gets you a
>> good step further than just the basic conversion.
>
> If you have a public branch for the latter, send it our way.  We can
> help with the SRSI testing.

Thanks, I'll get it setup next week.

>> The only problem area I ran into was the special case of the unaligned
>> writes.
>
> Yup, it's a painful limitation.  If you need any p420m hardware, let me
> know.

Sure, a card for testing is always useful.

-- 
Jens Axboe


