Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423533Ab3CVW6B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 18:58:01 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:44500 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423504Ab3CVW57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 18:57:59 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
References: <20130321233630.GE21522@ZenIV.linux.org.uk>
	<CA+55aFyLJ9vVm1T994EaE4tnEbV8rHj43m+cWsFFBi_qndao1A@mail.gmail.com>
	<CA+55aFyWNkOnrQ41xCAU8q5sVXdq1-u2P8n+quLY50OdiFo3Zw@mail.gmail.com>
	<20130322001257.GH21522@ZenIV.linux.org.uk>
	<CA+55aFz5Ce7h2ja0m++tENXuG-1d346VNu9N=ZKy2UfojaSf0g@mail.gmail.com>
	<20130322012208.GJ21522@ZenIV.linux.org.uk>
	<CA+55aFzPD08kJi=x8wLBi5FAjr1TqSGXWbv5KXy5Ymm0PJL0wA@mail.gmail.com>
	<20130322014037.GK21522@ZenIV.linux.org.uk>
	<20130322043715.GL21522@ZenIV.linux.org.uk>
	<CA+55aFzUobqDR0RSh8t18m32BdTvm4k7j2PCseXpFVCH_gR=Fw@mail.gmail.com>
	<20130322051817.GM21522@ZenIV.linux.org.uk>
	<CA+55aFzbV81KQh_f0=wti9=_6=PXu37z0+NJymhDvzv13GgpuA@mail.gmail.com>
	<CA+55aFwACJ+JQHMTGf7waFOygOV8NA0nRhnJVZJg6+bV_7O=4g@mail.gmail.com>
Date: Fri, 22 Mar 2013 15:57:50 -0700
In-Reply-To: <CA+55aFwACJ+JQHMTGf7waFOygOV8NA0nRhnJVZJg6+bV_7O=4g@mail.gmail.com>
	(Linus Torvalds's message of "Fri, 22 Mar 2013 12:43:50 -0700")
Message-ID: <874ng3m49d.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/s98HaKln0U/zSQtxh5egQZxpRtaysATk=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: Re: [CFT] Re: VFS deadlock ?
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> Regardless, the patch seems to be the right thing to do. It actually
> simplifies /proc, seems to fix the problem for Dave, and is small and
> should be trivial to backport. I've committed it and marked it for
> stable. Let's hope there won't be any nasty surprises, but it does
> seem to be the simplest non-hacky patch.

Thanks for pushing this to completion.

I thought I had fixed this several years ago by not reusing the
directory inodes under /proc/net but apparently that never happened.

Eric
