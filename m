Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105Ab3FTKVL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 06:21:11 -0400
Received: from intranet.asianux.com ([58.214.24.6]:60721 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845Ab3FTKVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 06:21:09 -0400
X-Spam-Score: -100.8
Message-ID: <51C2D762.4000207@asianux.com>
Date: Thu, 20 Jun 2013 18:20:18 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: timer: looping issue, need reset variable 'found'
References: <51B4A408.4050909@asianux.com> <alpine.LFD.2.02.1306101501160.22970@ionos> <51C039A8.5000903@asianux.com> <alpine.DEB.2.02.1306200944530.4013@ionos.tec.linutronix.de> <51C2BCB3.4060603@asianux.com> <alpine.DEB.2.02.1306201029390.4013@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1306201029390.4013@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2013 05:13 PM, Thomas Gleixner wrote:
> On Thu, 20 Jun 2013, Chen Gang wrote:
>> > On 06/20/2013 03:47 PM, Thomas Gleixner wrote:
>> > -------------------------------------------------------------------------------
>> > If we assume "If there is nothing in tv2 which might come before the
>> > found timer, then any timer in tv3 will ..." is correct.
>> > 
>> > When we found a timer in 'tv1', we will not search all timers in 'tv2'
>> > (we only search first looping of tv2 for the specific 'slot').
> Yes, because that's how the timer wheel works. And I'm not going to
> explain you every little detail of it.
>  

OK, thanks.

>> > Is it still OK ?
> Yes, it is. 
> 

OK, thanks.

>> > If you do not want to discuss with others, better quite politely, not
>> > need judging or checking others, it is useless for the cooperation with
>> > each other, is it right ?  ;-)
> I discussed all your patches which fall into my area of responsibility
> with you and I explained to you very politely why your patches are
> incorrect.
> 

Firstly, thank you for your explanations in details in your area of
responsibility.

At least this means you are warm-hearted, and can spend your time
resources on it.


> When I noticed, that you do not even understand how the timer wheel
> works in detail, which is necessary to understand why the code in
> __next_timer_interrupt() is correct, I asked you politely:
> 

I really do not know about the timer wheel works in detail.

I never said I am familiar with kernel, in fact, I often said I am not
quite familiar with kernel (you can find it in my many other replying
mails).

Is it necessary to give some related comments for it (the 'found' is
really in an informal using way) ?

We'd better let our code much readable for 'many readers' (which may not
know about more details, e.g. timer wheel).

Do my reply politely ?  ;-)


>>> > > Then I recommend that you to sit down and analyze the correctness of
>>> > > the code.
> And you answered:
> 
>> > That is only your recommend, not mean I have duty to.
> Right, it's only a recommendation. Though without proof of a failure,
> I'm not going to discuss that further and I'm not going to apply a
> patch.

OK.

For cooperation, every members are joined with their own willing, not by
force, but really need duty.

This time, it does not need duty, it is really a recommend.


Thanks.
-- 
Chen Gang

Asianux Corporation
