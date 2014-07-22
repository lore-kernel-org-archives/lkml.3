Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979AbaGVPzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 11:55:38 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:33499 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408AbaGVPzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 11:55:37 -0400
Message-ID: <53CE897F.4090308@linaro.org>
Date: Tue, 22 Jul 2014 10:55:43 -0500
From: Alex Elder <elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@suse.de>
CC: akpm@linux-foundation.org, kay@vrfy.org, pmladek@suse.cz,
        john.stultz@linaro.org, jack@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] printk: more log flag simplification
References: <1406037717-9670-1-git-send-email-elder@linaro.org> <20140722142456.GB10670@pd.tnic>
In-Reply-To: <20140722142456.GB10670@pd.tnic>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2014 09:24 AM, Borislav Petkov wrote:
> On Tue, Jul 22, 2014 at 09:01:55AM -0500, Alex Elder wrote:
>> This series eliminates the LOG_CONT entirely from the printk/log code.
>> It builds on another series, posted earlier today:
>>     http://www.spinics.net/lists/kernel/msg1791665.html
>> This series was originally longer, but in review I was reminded
>> that some of the simplifications I had done were not valid.
>>
>> The first patch exploits the fact that LOG_CONT and LOG_NEWLINE
>> are inverses, and uses LOG_NEWLINE (or its negation) anywhere
>> LOG_CONT is used.  As a result, LOG_CONT is no longer needed, so
>> it's eliminated.
>>
>> The second patch improves some comments and makes a few small
>> code cleanups, now that it's gone through this transformation.
> 
> This is getting ridiculous - you've been spamming me with printk patches
> like crazy every day! I told you to wait a bit with a resend until
> people have had a chance to review them, but you don't seem to care.
> 
> Would you please remove me from your CC list?

Yes.	-Alex

> Thank you.
> 

