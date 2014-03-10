Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245AbaCJT4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 15:56:19 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:34771 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908AbaCJT4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 15:56:14 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Eric Paris <eparis@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>, rgb@redhat.com,
        linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <874n3ir0uw.fsf_-_@xmission.com> <87mwhaplo4.fsf_-_@xmission.com>
	<20140304133004.b565820f60f595a48e621e58@linux-foundation.org>
	<20140304.165122.445822929490466603.davem@davemloft.net>
	<87mwh5d1tf.fsf@xmission.com>
	<20140304145037.d46ee775d293dd1ad60aa8e3@linux-foundation.org>
	<87bnxesqf0.fsf_-_@xmission.com> <1394459944.17193.12.camel@localhost>
Date: Mon, 10 Mar 2014 12:56:06 -0700
In-Reply-To: <1394459944.17193.12.camel@localhost> (Eric Paris's message of
	"Mon, 10 Mar 2014 09:59:04 -0400")
Message-ID: <87r469rfop.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19ytgJxi3he+/qGDyJZrFQC+x7SLy51rg4=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2512]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.0 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Eric Paris <eparis@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [GIT PULL] namespaces fixes for 3.14-rcX
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris <eparis@redhat.com> writes:

> On Sun, 2014-03-09 at 20:06 -0700, Eric W. Biederman wrote:
>> My efforts to get these fixes noticed by people who care about audit
>> seem to have landed on deaf ears, so since these are namespace related I
>> have put them in my tree.
>
> This commentary sounds like a pile of crap seeing as how there was a
> whole discussion around how to handle this stuff, which you were a part
> of.  And that the audit tree already picked up these 2 patches.

My apologies for offending.  Last night when I looked the audit tree had
not been updated in 7 weeks, and Andrew Morton wasn't ready to push
these fixes to Linus and was looking for someone who would.  Keeping
important bug fixes in my retransmit queue leaves me very grumpy.

> In any case, since I haven't sent them to Linus and I'm glad that is
> done, so feel free to consider this me Acking the pull request.

Eric
