Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbaHFFUB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 01:20:01 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:38392 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbaHFFT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 01:19:58 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <87fvhav3ic.fsf@x220.int.ebiederm.org>
	<20140806144643.45e5dab8@canb.auug.org.au>
Date: Tue, 05 Aug 2014 22:16:06 -0700
In-Reply-To: <20140806144643.45e5dab8@canb.auug.org.au> (Stephen Rothwell's
	message of "Wed, 6 Aug 2014 14:46:43 +1000")
Message-ID: <87lhr2tcyx.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18QgEkFpQZrVLmcOCrRdU3k6hlAcZ1WWd0=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1280]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.0 XMSubMetaSx_00 1+ Sexy Words
	*  1.0 T_XMDrugObfuBody_04 obfuscated drug references
	*  1.0 XMSexyCombo_01 Sexy words in both body/subject
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Stephen Rothwell <sfr@canb.auug.org.au>
X-Spam-Relay-Country: 
Subject: Re: [GIT PULL] namespace updates for v3.17-rc1
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi Eric,
>
> On Tue, 05 Aug 2014 17:57:31 -0700 ebiederm@xmission.com (Eric W. Biederman) wrote:
>>
>> Please pull the for-linus branch from the git tree:
>> 
>>    git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git for-linus
>> 
>>    HEAD: 344470cac42e887e68cfb5bdfa6171baf27f1eb5 proc: Point /proc/mounts at /proc/thread-self/mounts instead of /proc/self/mounts
>
> This has had 4 commits added since the merge window opened that have no
> Reviewed-by, Acked-by or Tested-by tags and only one Signed-off-by
> tag.

I am not certain what your point is.

There have been no commits added since the merge window opened.

There was one commit changed to fix a typo.  I documented that already.

There were some commits pushed to the tree as late as friday that had
been out for review earlier than that and it is possible that you did
not pick them up in linux-next until monday.  That doesn't mean I added
anything after the merge window opened.

I have also made certain all of these commits have at least had a chance
to show up in linux-next.

As for missing cool tags shrug.  The people looking at my code didn't
feel like saying the magic words so I didn't include cool tags.
Furthermore the code is all quite trivial.

Beyond that I have been quite out of it recently and this is what I had
time to do.  If I had had a little more time and energy I would have
included unmount on unlink patches that still need magic to happen to
keep from blowing the stack in pathological cases on everything except
x86_64.  That code has been sitting in linux-next.

Which is a my long winded way of say it sounds like you are accusing me
of being irresponsible, and my way of saying that I have tested and
vetted these trivial patches and been as careful as I reasonably could,
and I that I apologise for not being able to do things a few days
earlier.

Eric
