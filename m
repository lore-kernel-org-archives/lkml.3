Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424AbaHUOO7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 10:14:59 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:52817 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195AbaHUOO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 10:14:57 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Richard Weinberger <richard@nod.at>
Cc: Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "libvir-list\@redhat.com" <libvir-list@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>
References: <87fvhav3ic.fsf@x220.int.ebiederm.org>
	<CAFLxGvwi-iJRyfwv8v9fcRkiSu2d-az8W55xMPbp_d8wQKmwjg@mail.gmail.com>
	<87vbpm4f4y.fsf@x220.int.ebiederm.org>
	<20140821131257.GA4264@infradead.org> <53F5F2AD.5010607@nod.at>
Date: Thu, 21 Aug 2014 09:09:50 -0500
In-Reply-To: <53F5F2AD.5010607@nod.at> (Richard Weinberger's message of "Thu,
	21 Aug 2014 15:22:53 +0200")
Message-ID: <87k362vsr5.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18s//FuXUk60hD+sFHmStWtVXZFVsIwE/0=
X-SA-Exim-Connect-IP: 107.0.249.3
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4987]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.0 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Richard Weinberger <richard@nod.at>
X-Spam-Relay-Country: 
Subject: Re: [GIT PULL] namespace updates for v3.17-rc1
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger <richard@nod.at> writes:

> Am 21.08.2014 15:12, schrieb Christoph Hellwig:
>> On Wed, Aug 20, 2014 at 09:53:49PM -0700, Eric W. Biederman wrote:
>>> Richard Weinberger <richard.weinberger@gmail.com> writes:
>>>
>>>> On Wed, Aug 6, 2014 at 2:57 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>>>
>>>> This commit breaks libvirt-lxc.
>>>> libvirt does in lxcContainerMountBasicFS():
>>>
>>> The bugs fixed are security issues, so if we have to break a small
>>> number of userspace applications we will.  Anything that we can
>>> reasonably do to avoid regressions will be done.
>> 
>> Can you explain the security issues in detail?  Breaking common
>> userspace like libvirt-lxc with just a little bit of handwaiving is
>> entirely unacceptable.
>
> It looks like commit 87b47932f40a11280584bce260cbdb3b5f9e8b7d in
> git.kernel.org/cgit/linux/kernel/git/ebiederm/user-namespace.git for-next
> unbreaks libvirt-lxc.
> I hope it hits Linus tree and -stable before the offending commit hits users.

I plan to send the pull request to Linus as soon as I have caught my
breath (from all of the conferences this week) that I can be certain I
am thinking clearly and not rushing things.

Eric
