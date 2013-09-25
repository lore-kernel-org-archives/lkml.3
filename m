Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757714Ab3IYBIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:08:00 -0400
Received: from intranet.asianux.com ([58.214.24.6]:33823 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757697Ab3IYBH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 21:07:58 -0400
X-Spam-Score: -100.7
Message-ID: <5242372C.4010509@asianux.com>
Date: Wed, 25 Sep 2013 09:06:52 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH] kernel/groups.c: consider about NULL for 'group_info'
 in all related extern functions
References: <5212DBFA.8030805@asianux.com> <20130923150625.GB14547@htj.dyndns.org> <52410A40.1000304@asianux.com> <20130924040601.GA31575@mtj.dyndns.org> <524114B8.3070903@asianux.com> <20130924120429.GA2366@htj.dyndns.org> <5242331B.4010309@asianux.com> <20130925005802.GA25777@htj.dyndns.org>
In-Reply-To: <20130925005802.GA25777@htj.dyndns.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2013 08:58 AM, Tejun Heo wrote:
> Hello, Chen.
> 
> On Wed, Sep 25, 2013 at 08:49:31AM +0800, Chen Gang wrote:
>>> Can you please demonstrate such failure?  You can tell kernel to
>>> execute a given binary instead of init with "init=" param.
>>
>> OK, I will/should try, today (although I have to spend my additional
>> time resource on it. :-( ).
> 
> Please note that that's not necessarily "additional" resource that you
> spend.  It's more of something necessary to justify the changes you're
> suggesting.  It's true that not all bug fixes / improvements require
> explicit demonstration but I'm not very convinced about your analysis
> partly because I'm not too familiar with the code path but also
> because the code has been stable with years and you seem pretty new to
> the area.
> 
>> Hmm... in fact, in my opinion, interface (especially content system
>> call) need make itself consistency, although at present, it can not
>> cause issue.
> 
> Sure, it should be consistent but I'm not sure what you're perceiving
> as inconsistent is actually inconsistent.  Anyways, let's please have
> something deomnstratable.  We can think more about the interface
> niggles afterwards.
> 
> Thanks.
> 

OK, I see, the 'root cause' is: "you are not the related maintainer
either", so it is really necessary for me to spend additional time
resource on it :-(.

But all together, thank you for spending your time resource on it, let
us continue :-).


Thanks.
-- 
Chen Gang
