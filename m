Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760051Ab3JPCJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 22:09:18 -0400
Received: from intranet.asianux.com ([58.214.24.6]:25341 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760004Ab3JPCIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 22:08:49 -0400
X-Spam-Score: -100.8
Message-ID: <525DF4F0.3070901@asianux.com>
Date: Wed, 16 Oct 2013 10:07:44 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: josh@freedesktop.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/rcutorture.c: use scnprintf() instead of sprintf()
References: <5253C335.5050609@asianux.com> <20131013110518.GC5790@linux.vnet.ibm.com> <525BAD9F.6060406@asianux.com> <20131014112839.GO5790@linux.vnet.ibm.com> <525C9256.5010002@asianux.com> <525C9FAE.4090209@asianux.com> <20131015082613.GG5790@linux.vnet.ibm.com> <525D35E9.3000604@asianux.com> <20131015144732.GG9150@linux.vnet.ibm.com>
In-Reply-To: <20131015144732.GG9150@linux.vnet.ibm.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2013 10:47 PM, Paul E. McKenney wrote:
> On Tue, Oct 15, 2013 at 08:32:41PM +0800, Chen Gang wrote:
>> Yeah, that is a way for it. It seems you (related maintainer) like
>> additional fix for it.
>>
>> Hmm... I will try within this week (although I don't think it is quite
>> necessary to me).
>>
>> :-)
> 
> If you always ensure that the buffer is big enough, do you really need
> the checking?
> 

Since they are all normal static functions: Of cause not need length
checking, either don't need return value, either don't need local
variable 'cnt'.

>>
>> Excuse me, my English is not quite well, I am not quite understand your
>> meaning.
>>
>> I guess your meaning is: "after find a simple/acceptable solution, we
>> can think of more, it may be more efficient".
>>
>> If what I guess is correct, It is OK to me -- since at least, it is not
>> an 'urgent' thing (for 'important' thing, your idea is more efficient,
>> although for 'urgent' thing, it is not).
> 
> That is important as well -- the first solution you think of might not
> be the right one.
> 

In my opinion, my first solution is correct, simple, and acceptable
enough for a test module, although it may be not the simplest, or not
most acceptable one.

> My point is related.  If you believe you found a bug by inspection,
> it is often worth testing to be sure.  Especially if the code in
> question is at all complex.
> 

Yeah, "it is often worth testing to be sure": it is related with test
case which based on the demands (so demands/requirement is the first),
in fact, most of maintainers will not give much focus on a test module.

The reason why I still will spend more time resource on test module is:
"since the related maintainer wants to focus on it, if it isn't urgent,
I will spend more time resource on it".

For 'important' but not 'urgent' thing (I assume your demands belong to
'important' thing), often need a trigger, if no triggers, better not
touch it now (it is not quite efficient). Now you are the 'trigger'. ;-)


> 							Thanx, Paul
> 
> 
> 


Thanks.
-- 
Chen Gang
