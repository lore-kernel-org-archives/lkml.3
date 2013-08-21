Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339Ab3HUHKq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 03:10:46 -0400
Received: from intranet.asianux.com ([58.214.24.6]:2507 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab3HUHKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 03:10:45 -0400
X-Spam-Score: -101.0
Message-ID: <52145F5C.9090907@asianux.com>
Date: Wed, 21 Aug 2013 14:34:04 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Joe Perches <joe@perches.com>, "'Jiri Kosina'" <trivial@kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, davej@redhat.com,
        Arnd Bergmann <arnd@arndb.de>, David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH trivial] UAPI: Kbuild: add/modify comments for "uapi/Kbuild"
 and "uapi/linux/Kbuild"
References: <52005571.4080704@asianux.com> <1375810303.2424.28.camel@joe-AO722> <1375860749.8422.25@driftwood> <520209FA.70409@asianux.com> <5202FEC3.4010408@asianux.com>
In-Reply-To: <5202FEC3.4010408@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all:

According to the reply of yours, it seems we need more 'work' for the
API related documents.  If really it is, I need change my 'work' way
for it.

Currently, my 'work' way is "finding and solving issues", which may be
efficient for 'grow up' sub-systems (e.g. "kernel/" sub-system).

But for the sub-systems which are lack of main contents (or too many
issues to solve), I think the efficient way is "get 'tasks' from the
related maintainers and finish 'tasks' one by one".

If the related maintainers agree with me, they can send 'tasks' to me,
and I am glad to finish them one by one.


Reason (why I am glad to do it):

  1. The API related documents are really important for us, and currently need more 'work'.
  2. 'getting tasks' is an efficient way for it.
  3. it is additional good chance to me for English training (I should do additional trying to improve my English).


Limitations (my resources):

  1. finish one API document related task per month (excuse me, I have no additional time resources for it).
  2. my English is not quite well, it may have negative effect with the efficiency.
  3. sometimes, I can not connect to net, which may not give response in time.

     e.g. recently, 2013-08-08 -- 2013-08-19, but I may still can 'work' for it (queue patches and waiting the network OK).


BTW: I also can try the English-Chinese translations tasks. ;-)


Thanks.


On 08/08/2013 10:13 AM, Chen Gang wrote:
> Hello Rob:
> 
> Maybe I misunderstand what you said (if so, I am sorry for it).
> 
> At least for me, what you said is valuable to get additional discussion,
> but it seems better to start a new thread for it and also cc to
> linux-doc mail list.
> 
> If so better include me in cc list, thanks.  ;-)
> 
> If you think still suitable to discuss about it in this mail thread,
> please continue, at least, I still welcome.  :-)
> 
> 
> Thanks.
> 
> On 08/07/2013 04:48 PM, Chen Gang wrote:
>> On 08/07/2013 03:32 PM, Rob Landley wrote:
>>> On 08/06/2013 12:31:43 PM, Joe Perches wrote:
>>>> On Tue, 2013-08-06 at 09:46 +0800, Chen Gang wrote:
>>>>> "include/uapi/" is the whole Linux kernel API, it is important enough
>>>>> to get more global explanations by comments.
>>>>
>>>> It'd probably be useful to have more descriptions
>>>> of uapi in the Documentation directory too.
>>>
>>> I'd rather have comments in the headers that get exported to userspace
>>> and then have other forms of documentation generated from that by some
>>> process similar to "make htmldocs". Otherwise you've got two places to
>>> keep in sync.
>>>
>>
>> At least for me, it is a good idea, although UAPI files is rarely
>> changed (may add new item, but few modifying the existing items).
>>
>> And for our case, it is summary comments for directory organization for
>> all UAPI files, so in my opinion, it is still necessary to give summary
>> comments in Kbuild.
>>
>> In Linux user mode or another OS which share the same files of UAPI,
>> they do not care about our kernel's Kbuild, for they have their own
>> directory organizations which may different with Linux kernel's.
>>
>>> (Really the guy you've got to keep in the loop about this is Michael
>>> Kerrisk. The section 2 man pages are the current best reference on UAPI
>>> stuff...)
>>>
>>
>> As far as I know, the section 2 man pages is already for it (e.g. man 2
>> setfuid, man 2 open, ...).
>>
>> Do you mean currently it is only for some of system calls (part of
>> UAPI), not for the whole UAPI ?
>>
>>
>>> Rob
>>>
>>
>>
> 
> 


-- 
Chen Gang
