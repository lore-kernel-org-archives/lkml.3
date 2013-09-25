Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751140Ab3IYEfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 00:35:31 -0400
Received: from intranet.asianux.com ([58.214.24.6]:53673 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab3IYEfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 00:35:30 -0400
X-Spam-Score: -100.8
Message-ID: <524267CD.4030007@asianux.com>
Date: Wed, 25 Sep 2013 12:34:21 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH] kernel/groups.c: consider about NULL for 'group_info'
 in all related extern functions
References: <5212DBFA.8030805@asianux.com> <20130923150625.GB14547@htj.dyndns.org> <52410A40.1000304@asianux.com> <20130924040601.GA31575@mtj.dyndns.org> <524114B8.3070903@asianux.com> <20130924120429.GA2366@htj.dyndns.org> <5242331B.4010309@asianux.com> <20130925005802.GA25777@htj.dyndns.org> <5242372C.4010509@asianux.com> <20130925011404.GB25777@htj.dyndns.org> <52424094.3020504@asianux.com>
In-Reply-To: <52424094.3020504@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2013 09:47 AM, Chen Gang wrote:
> On 09/25/2013 09:14 AM, Tejun Heo wrote:
>> On Wed, Sep 25, 2013 at 09:06:52AM +0800, Chen Gang wrote:
>>> OK, I see, the 'root cause' is: "you are not the related maintainer
>>> either", so it is really necessary for me to spend additional time
>>> resource on it :-(.
>>
>> Yeah, at least partly.  That and the fact that I'm not too willing to
>> dig into the code without further evidence.  It isn't anything strange
>> to ask tho and I'm likely to do that even for subsystems that I know
>> intimately if the subject code has been stable / stale for years and
>> the analysis doesn't seem immediately convincing.  And, if my
>> experience is anything to go by, it's not too unlikely that you might
>> hit something which doesn't agree with your current assumptions while
>> trying to actually trigger the problem.
>>
>> Thanks.
>>
> 

Excuse me, I have to do some urgent internal things within my company,
so the test and confirmation may be delayed (I will try to finish test
within this month: 2013-09-30).

> Excuse me, my English is not quite well, I do not quite understand what
> you said (but it seems what you said is reasonable, and not need reply).
> 
> 
> Thanks.
> 


-- 
Chen Gang
