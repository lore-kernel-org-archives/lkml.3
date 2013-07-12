Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657Ab3GLD0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 23:26:19 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:60099 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756475Ab3GLD0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 23:26:17 -0400
Message-ID: <51DF773F.8010506@huawei.com>
Date: Fri, 12 Jul 2013 11:25:51 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <stable@vger.kernel.org>,
        <ksummit-2013-discuss@lists.linux-foundation.org>
Subject: Re: When to push bug fixes to mainline
References: <20130711214830.611455274@linuxfoundation.org> <20130712005023.GB31005@thunk.org>
In-Reply-To: <20130712005023.GB31005@thunk.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/7/12 8:50, Theodore Ts'o wrote:
> On Thu, Jul 11, 2013 at 03:01:17PM -0700, Greg Kroah-Hartman wrote:
>> <rant>
>>   I'm sitting on top of over 170 more patches that have been marked for
>>   the stable releases right now that are not included in this set of
>>   releases.  The fact that there are this many patches for stable stuff
>>   that are waiting to be merged through the main -rc1 merge window cycle
>>   is worrying to me.
>>
>>   Why are subsystem maintainers holding on to fixes that are
>>   _supposedly_ affecting all users?  I mean, 21 powerpc core changes
>>   that I don't see until a -rc1 merge?  It's as if developers don't
>>   expect people to use a .0 release and are relying on me to get the
>>   fixes they have burried in their trees out to users.  That's not that
>>   nice.  6 "core" iscsi-target fixes?  That's the sign of either a
>>   broken subsystem maintainer, or a lack of understanding what the
>>   normal -rc kernel releases are supposed to be for.
> 
> At least at one point in the past, the rule that Linus had laid down
> after discussing things at Kernel Summits was after -rc2, or maybe
> -rc3 at the latest, the ***only*** fixes that should be sent to Linus
> would be for regression fixes or for really serious data integrity
> issues.  The concern was that people were pushing bug fixes in -rc5 or
> -rc6 that were in some cases causing regressions.
> 
> (As I recall, Linus laid down the law regarding this policy in his own
> inimitable and colorful style; which today would result in all sorts
> of tsk, tsking on Hacker News regarding his language.  :-)
> 
> In any case, I've been very conservative in _not_ pushing bug fixes to
> Linus after -rc3 (unless they are fixing a regression or the bug fix
> is super-serious); I'd much rather have them cook in the ext4 tree
> where they can get a lot more testing (a full regression test run for
> ext4 takes over 24 hours), and for people trying out linux-next.
> 
> Maybe the pendulum has swung too far in the direction of holding back
> changes and trying to avoid the risk of introducing regressions;
> perhaps this would be a good topic to discuss at the Kernel Summit.
> 

Looks like each maintainer may have his rule which may differ from the
rule laid down by Linus.

I have 2 network patches which went into 3.10-rc6, though these two bugs
are not regressions but has been there even before the git history.

On the other hand, 2 of my cgroup bug fixes were queued for 3.11 with
stable tag added.

And what about Documentation fixes and updates? Should those patches
also follow Linus' rule? I guess people have different opinions.

