Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280Ab3CGIbk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 03:31:40 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:44769 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509Ab3CGIbi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 03:31:38 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: mtk.manpages@gmail.com
Cc: Rob Landley <rob@landley.net>, linux-man <linux-man@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
References: <CAKgNAki=mUYuu_Ewhe7sjCmo+Dq2Vr+FZCixqNRaadcvAxtpFw@mail.gmail.com>
	<1362110504.15531.4@driftwood>
	<CAKgNAkgVKnhRT1Lpq4a_UdBKB+tn6XmWSDF2QJXG0aSLtNH6dg@mail.gmail.com>
	<87wqtr3zg5.fsf@xmission.com>
	<CAKgNAkjGD0FdQqpA+rYR=+Yc5uVPB8mE5JjCqy-5WS85cPsvng@mail.gmail.com>
	<87k3pnhx2k.fsf@xmission.com>
	<CAKgNAkjYmvjMzC+nYqsjHf4bQn2ZwdE5wawoP2p32ZSo+0dfcQ@mail.gmail.com>
	<87r4jucprp.fsf@xmission.com>
	<CAKgNAkgqE7owqsmD+9-9fZtzMQ76H53a+Aat0CH670jNTUfbFA@mail.gmail.com>
	<87boax4axy.fsf@xmission.com>
	<CAKgNAkgRs7kg5PsMrBDNO8_z=5L5zM7DmLgU8pNwT_ck4Hmvhw@mail.gmail.com>
Date: Thu, 07 Mar 2013 00:31:29 -0800
In-Reply-To: <CAKgNAkgRs7kg5PsMrBDNO8_z=5L5zM7DmLgU8pNwT_ck4Hmvhw@mail.gmail.com>
	(Michael Kerrisk's message of "Thu, 7 Mar 2013 09:20:13 +0100")
Message-ID: <878v5zy5jy.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-AID: U2FsdGVkX1+3T1n7B3bERH+0CqgkKuxKEICbKYCnCpY=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0313]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.1 XMSolicitRefs_0 Weightloss drug
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;mtk.manpages@gmail.com
X-Spam-Relay-Country: 
Subject: Re: For review: pid_namespaces(7) man page
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:

> On Wed, Mar 6, 2013 at 1:40 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
>>
>>> On Tue, Mar 5, 2013 at 7:41 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>>> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
>>>>
>>>>> Eric,
>>>>>
>>>>> On Mon, Mar 4, 2013 at 6:52 PM, Eric W. Biederman
>>>>> <ebiederm@xmission.com> wrote:
>>>>>> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
>>>>>>
>>>>>>> On Fri, Mar 1, 2013 at 4:35 PM, Eric W. Biederman
>>>>> <ebiederm@xmission.com> wrote:
>>>>>>>> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
>>>>>>>>
>>>>>>>>> Hi Rob,
>>>>>>>>>
>>>>>>>>> On Fri, Mar 1, 2013 at 5:01 AM, Rob Landley <rob@landley.net>
>>>>> wrote:
>>>>>>>>>> On 02/28/2013 05:24:07 AM, Michael Kerrisk (man-pages) wrote:
>>>>> [...]
>>>>>>>>>>> Because the above unshare(2) and setns(2) calls only change the
>>>>>>>>>>> PID namespace for created children, the clone(2) calls neces‐
>>>>>>>>>>> sarily put the new thread in a different PID namespace from the
>>>>>>>>>>> calling thread.
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> Um, no they don't. They fail. That's the point.
>>>>>>>>>
>>>>>>>>> (Good catch.)
>>>>>>>>>
>>>>>>>>>> They _would_ put the new
>>>>>>>>>> thread in a different PID namespace, which breaks the definition
>>>>> of threads.
>>>>>>>>>>
>>>>>>>>>> How about:
>>>>>>>>>>
>>>>>>>>>> The above unshare(2) and setns(2) calls change the PID namespace
>>>>> of
>>>>>>>>>> children created by subsequent clone(2) calls, which is
>>>>> incompatible
>>>>>>>>>> with CLONE_VM.
>>>>>>>>>
>>>>>>>>> I decided on:
>>>>>>>>>
>>>>>>>>> The point here is that unshare(2) and setns(2) change the PID
>>>>>>>>> namespace for created children but not for the calling process,
>>>>>>>>> while clone(2) CLONE_VM specifies the creation of a new thread
>>>>>>>>> in the same process.
>>>>>>>>
>>>>>>>> Can we make that "for all new tasks created" instead of "created
>>>>>>>> children"
>>>>>>>>
>>>>>>>> Othewise someone might expect CLONE_THREAD would work as you
>>>>>>>> CLONE_THREAD creates a thread and not a child...
>>>>>>>
>>>>>>> The term "task" is kernel-space talk that rarely appears in man
>>>>> pages,
>>>>>>> so I am reluctant to use it.
>>>>>>
>>>>>> With respect to clone and in this case I am not certain we can
>>>>> properly
>>>>>> describe what happens without talking about tasks. But it is worth
>>>>>> a try.
>>>>>>
>>>>>>
>>>>>>> How about this:
>>>>>>>
>>>>>>> The point here is that unshare(2) and setns(2) change the PID
>>>>>>> namespace for processes subsequently created by the caller, but
>>>>>>> not for the calling process, while clone(2) CLONE_VM specifies
>>>>>>> the creation of a new thread in the same process.
>>>>>>
>>>>>> Hmm. How about this.
>>>>>>
>>>>>> The point here is that unshare(2) and setns(2) change the PID
>>>>>> namespace that will be used by in all subsequent calls to clone
>>>>>> and fork by the caller, but not for the calling process, and
>>>>>> that all threads in a process must share the same PID
>>>>>> namespace. Which makes a subsequent clone(2) CLONE_VM
>>>>>> specify the creation of a new thread in the a different PID
>>>>>> namespace but in the same process which is impossible.
>>>>>
>>>>> I did a little tidying:
>>>>>
>>>>> The point here is that unshare(2) and setns(2) change the
>>>>> PID namespace that will be used in all subsequent calls
>>>>> to clone(2) and fork(2), but do not change the PID names‐
>>>>> pace of the calling process. Because a subsequent
>>>>> clone(2) CLONE_VM would imply the creation of a new
>>>>> thread in a different PID namespace, the operation is not
>>>>> permitted.
>>>>>
>>>>> Okay?
>>>>
>>>> That seems reasonable.
>>>>
>>>> CLONE_THREAD might be better to talk about.  The check is CLONE_VM
>>>> because it is easier and CLONE_THREAD implies CLONE_THREAD.
>>>>
>>>>> Having asked that, I realize that I'm still not quite comfortable with
>>>>> this text. I think the problem is really one of terminology. At the
>>>>> start of this passage in the page, there is the sentence:
>>>>>
>>>>> Every thread in a process must be in the
>>>>> same PID namespace.
>>>>>
>>>>> Can you define "thread" in this context?
>>>>
>>>> Most definitely a thread group created with CLONE_THREAD.  It is pretty
>>>> ugly in just the old fashioned CLONE_VM case too, but that might be
>>>> legal.
>>>>
>>>> In a few cases I think the implementation overshoots and test for VM
>>>> sharing instead of thread group membership because VM sharing is easier
>>>> to test for, and we already have tests for that.
>>>
>>> So, in summary, the point is that CLONE_VM is being used as a proxy
>>> for CLONE_THREAD because the former is easier to test for, and
>>> CLONE_THREAD requires CLONE_VM, right?
>>
>> I am totally lost about what we are problem we are trying to resolve in
>> the text at this point.  So I am taking this opportunity to review
>> what is actually happening and hopefully give a clear and useful
>> explanation.
>
> The problem is that the existing text talks about multithreaded
> processes needing to be in the same PID namespace and then jumps to
> talking about restrictions with CLONE_VM (not CLONE_THREAD). The
> reader may not realize know that CLONE_VM is a near synonym for
> "multithreaded process".
>
> However, the text you provide here is wonderful detail:
>
>> The clone flags have some dependencies.
>> CLONE_SIGHAND requires CLONE_VM.
>> CLONE_THREAD requires CLONE_SIGHAND.
>>
>> Ultimately there are cases in here that are too strange to think about,
>> and that no one cares (except so far to document what is going on).  The
>> fundamental goal of these checks it to just not allow the cases that
>> are too strange to think about.
>>
>> From a technical point of view CLONE_THREAD requires being in the same
>> PID namespace so you can send signals to other threads in your process,
>> and you need to see in proc all of the threads of your process.
>>
>> From a technical point of view CLONE_SIGHAND requries being in the same
>> PID namespace because we need to know how to encode the PID of the
>> sending process at the time a signal is enqueued in the destination
>> queue.  A signal queue shared by processes in multiple PID namespaces
>> will defeat that.
>>
>> From a technical point of view CLONE_VM requires all of the threads to
>> be in a PID namespace, because from the point of view of coredump code
>> if two processes share the same address space they are threads and will
>> be core dumped together.  When a coredump is written the pid of each
>> thread is written into the coredump.  Writing the pids could not
>> meaningfully succeed if some of the pids were in a parent PID namespace.
>>
>> Therefore there is a technical requirement for each of CLONE_THREAD,
>> CLONE_SIGHAND, CLONE_VM to share a PID namespace.
>>
>> In the code in the kernel testing only for CLONE_VM is a shorthand for
>> testing for any of CLONE_THREAD, CLONE_SIGHAND, or CLONE_VM.
>
> I will incorporate most of the above into the page.
>
>> On the flip side the addition by unshare(CLONE_NEWPID) of
>> unshare(CLONE_THREAD) actually appears to be bogus
>
> I agree that it seems strange.

Having looked at it a little more I will be removing the unnecessary
CLONE_THREAD check in 3.10.

Eric
