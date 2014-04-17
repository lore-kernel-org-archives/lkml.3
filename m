Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751196AbaDQOvi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 10:51:38 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:44582 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaDQOvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 10:51:33 -0400
Message-ID: <534FEA74.70300@gopivotal.com>
Date: Thu, 17 Apr 2014 15:51:32 +0100
From: Glyn Normington <gnormington@gopivotal.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] control groups: documentation improvements
References: <53225C69.3010202@huawei.com> <53230475.5050805@gopivotal.com> <20140314140136.GF12613@htj.dyndns.org> <53230C7E.7060607@gopivotal.com> <533C05D8.8020600@gopivotal.com> <533C0DD9.1050809@gopivotal.com> <20140416210025.GE26632@htj.dyndns.org> <534FB0F5.3010904@gopivotal.com> <20140417131615.GH26632@htj.dyndns.org> <534FDB04.6050406@gopivotal.com> <20140417135528.GE15326@htj.dyndns.org>
In-Reply-To: <20140417135528.GE15326@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun

On 17/04/2014 14:55, Tejun Heo wrote:
> Hello,
>
> On Thu, Apr 17, 2014 at 02:45:40PM +0100, Glyn Normington wrote:
>>>> +The sets of subsystems participating in distinct hierarchies are either
>>>> +identical or disjoint. If the sets are identical, the virtual filesystems
>>>> +associated with the hierarchies have identical content and a change in
>>>> +one is automatically reflected in all the others.
>>> I can't say I'm a big fan of these definitions in mathematical terms.
>>> They're so precise and useless at the same time.
>> We would like to be both precise and readable. Please point out the
>> "useless" bits and we'll try to make them better.
> I think it becomes useless when mathematical precision is pursued
> beyond the necessary point, forcing people to parse and analyze the
> description to reach a concept she already has full understanding of.
> Just using those pre-established concepts is far more efficient use of
> brain power than trying to craft the precise mathematical definition
> from vacuum and, [un]surprisingly, leads to lower rate of
> miscommunication.
>
> It's kinda useless to go through all the precise terms to re-define
> hierarchical grouping of tasks, which is both accurate and intuitive
> enough.  Adding extra descriptions to clarify ambiguities and just to
> reinforce the concept would be fine but trying to build the concept
> from the ground is silly at best.  Starting with something intuitive
> and refining it is a far better approach.
I'm sorry you feel this way. A couple of us (full disclosure: both 
mathematicians) tried hard to get a precise understanding of cgroups 
from cgroups.txt, but several terms remained vague until we had done 
some experiments and discussed our findings on the mailing list.

The aim of the patch is to crisp up the definitions of those terms for 
other newcomers, so they won't have to go through the same exercise.

Interestingly, after we had understood the terms, cgroups.txt seemed 
much clearer than it did originally. But that's because we were tending 
to read our new-found understanding into the text. Might you not be 
doing the same?

So, how would you like to proceed? You could reject the patch outright 
if you think our experience is unrepresentative. Or, for the benefit of 
other newcomers, we are willing to try reworking the parts you find 
unreadable if you could kindly pick them out. The choice is yours. :-)
>
>> A given hierarchy may be associated with more than one virtual
>> filesystem, in which case each of the virtual filesystems has
>> identical contents to the others.
> The above is inaccurate because there really is just one filesystem
> (represented by a single super block).  There are multiple mount
> points of the same file system, but still just single file system.
> ie. mounting /dev/sdb2 in multiple places doens't really create
> multiple file systems.
Thanks for the clarification. If you agree to proceed, we should be able 
to find a simpler way to cover this paragraph.
>
> Thanks.
>
Regards,
Glyn
