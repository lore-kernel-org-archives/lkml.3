Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab3GIA04 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 20:26:56 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:50813 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab3GIA0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 20:26:55 -0400
Message-ID: <51DB588C.8070000@gmail.com>
Date: Tue, 09 Jul 2013 08:25:48 +0800
From: Chen Gang F T <chen.gang.flying.transformer@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Chen Gang <gang.chen@asianux.com>, lig.fnst@cn.fujitsu.com,
        chuansheng.liu@intel.com, Wang YanQing <udknight@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/smp.c: free related resources when failure occurs
 in hotplug_cfd()
References: <51DA7D50.8010209@asianux.com> <20130708142605.GA2786@windriver.com>
In-Reply-To: <20130708142605.GA2786@windriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/08/2013 10:26 PM, Paul Gortmaker wrote:
> [[PATCH] kernel/smp.c: free related resources when failure occurs in hotplug_cfd()] On 08/07/2013 (Mon 16:50) Chen Gang wrote:
> 
>> > When failure occurs in hotplug_cfd(), need release related resources,
>> > or will cause memory leak.
>> > 
>> > Also beautify the related code.
> No.  Please do not mix real fixes with trivial whitespace changes.
> It makes it harder for the reviewer to find the actual fix, and it
> makes the fix less portable to other releases (i.e. stable trees.)
> 

OH, at least, need delete white spaces.

> Also, you say "beautify", but that is a matter of opinion.  You
> shuffle around the tabs in your whitespace change, and yet even
> then you don't manage to adapt it to the general coding style of
> having multi-line args align with where the 1st arg starts.  So
> you have done nothing but pollute the "git blame" history of that
> file for other users.
> 

OK, I will send patch v2 for it (which will remove the waste
'beautifying' operation).

> You might want to slow down on the quantity of patches you send,
> and spend more time reading the comments from other people on
> reviewed patches and learning some of the implicit requirements
> from those.

No, that only means I still need improving my patch sending.

Hmm... for 'learning', I think: "learn with each other, never too old to
learn, never stop learning", so we can learn from most of patches or
replies which sent by many members.

e.g. I understand that for beautifying code, I need more consideration:
not only about coding style rules, but also the readers from 'git' and
the reviewers from 'diff'.

>             I've noticed that you are already dangerously close
> to annoying several key subsystem maintainers, and that is not
> the right long term approach to working with the linux community.

If no reply, I will(of cause) no reply either.

Especially, every members' time resource is always expensive.


Thanks.
-- 
Chen Gang
