Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab3B1HFo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 02:05:44 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:34472 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab3B1HFn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 02:05:43 -0500
MIME-Version: 1.0
In-Reply-To: <512EE2F5.2080900@oracle.com>
References: <EB937501617BFC44BE90EDA24CA6A13A0117EB@SGSIMBX003.nsn-intra.net>
	<512C56AF.1030801@oracle.com>
	<CAFLxGvyQmPz_iK26NavuRdBWAFiWzmt8BMfL8f6rg_Qm4LF7WQ@mail.gmail.com>
	<CAFLxGvycGCyeg7AhJ=3J0ztZfgYLmyKZSrzNUd5ymAb-tSd4qg@mail.gmail.com>
	<512EE2F5.2080900@oracle.com>
Date: Thu, 28 Feb 2013 08:05:41 +0100
Message-ID: <CAFLxGvyW+5RCReH8NuFVcgiqvRyHHyE5ZvuB7V8y5zbPzw=69w@mail.gmail.com>
Subject: Re: [Ocfs2-users] Kernel panic due to ocfs2
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Srinivas Eeda <srinivas.eeda@oracle.com>
Cc: "Ramappa, Ravi (NSN - IN/Bangalore)" <ravi.ramappa@nsn.com>,
        "ocfs2-users@oss.oracle.com" <ocfs2-users@oss.oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>, david@sigma-star.at
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 5:54 AM, Srinivas Eeda <srinivas.eeda@oracle.com> wrote:
> On 02/27/2013 03:52 AM, richard -rw- weinberger wrote:
>>
>> On Tue, Feb 26, 2013 at 8:54 AM, richard -rw- weinberger
>> <richard.weinberger@gmail.com> wrote:
>>>
>>> On Tue, Feb 26, 2013 at 7:31 AM, Srinivas Eeda <srinivas.eeda@oracle.com>
>>> wrote:
>>>>
>>>> This is due to a race in lock mastery/purge. I have recently fixed this
>>>> problem but haven't yet submitted the patch to mainline. Please file a
>>>> Service request with Oracle to get a one-off fix.
>>>
>>> Please submit the patch immediately.
>>> Why does one need a f§&"!#$ SR from Oracle to have this fixed?
>>
>> So, where can I find this patch?
>> Can you please share it with us insignificant and rubbishy community
>> folks?
>
> Here is the patch against mainline which I haven't yet submitted because I
> have not finished testing on mainline kernel yet. I am running into another
> unrelated crashes during testing. I am forwarding the patch to you assuming
> you are looking for this fix.
>
> https://oss.oracle.com/~seeda/patches/dlm-race/
>
> The other person who emailed about the problem was running older ocfs2
> version(1.4-10). Which is where I originally debugged, patched and tested
> the fix. So I offered to help him.

Thanks a lot for the patch!
Offering help is okay, but the SR thing had a really bad taste.
Iff mainline is not vulnerable, no problem but please communicate such
a fact clearly.
Also if your patch is not yet through your in-house QA, you can still
send an "hey-i-have-an-idea..."-patch.

Is the git repo listed in MAINTAINERS and the ocfs2 website still valid?
It looks kinda outdated...
git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2.git

OCFS2 development seems to be very opaque currently.

-- 
Thanks,
//richard
