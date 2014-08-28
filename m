Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbaH1Umw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 16:42:52 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:55814 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbaH1Umv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 16:42:51 -0400
Message-ID: <53FF9449.1000702@kernel.dk>
Date: Thu, 28 Aug 2014 14:42:49 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "tj@kernel.org" <tj@kernel.org>, "hch@lst.de" <hch@lst.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 3.17-rc2 percpu-ref oops with virtblk remove
References: <20140828185046.GR22580@arm.com> <53FF7A3A.7060607@kernel.dk> <20140828185458.GS22580@arm.com>
In-Reply-To: <20140828185458.GS22580@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2014 12:54 PM, Will Deacon wrote:
> On Thu, Aug 28, 2014 at 07:51:38PM +0100, Jens Axboe wrote:
>> On 08/28/2014 12:50 PM, Will Deacon wrote:
>>> Any ideas?
>>
>> It's fixed in for-linus, which will go out soon, more stuff just kept
>> coming in. Fix:
>>
>> http://git.kernel.dk/?p=linux-block.git;a=commit;h=cddd5d17642cc6881352732693c2ae6930e9ce65
> 
> Thanks Jens, at least it kept me entertained this afternoon.

Sorry, google could have helped you, though...

In any case, the branch has now been sent out for inclusion, so should
be gone shortly.


-- 
Jens Axboe

