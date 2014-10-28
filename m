Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbaJ1Rcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 13:32:48 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:58999 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaJ1Rcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 13:32:46 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Michael Kerrisk \(man-pages\)" <mtk.manpages@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Andrey Wagin <avagin@gmail.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <87lhp12a2i.fsf@x220.int.ebiederm.org>
	<CALCETrXGojRGtT1B2Aib7m54j8T+LsnCOin_GL93-BWf-eSPkA@mail.gmail.com>
	<87oatxzwex.fsf@x220.int.ebiederm.org>
	<CALCETrUOeCrjAy---FM-8ovU1FD372ShgBeS5_1LUkgRWMQ4gQ@mail.gmail.com>
	<544F9D7D.40301@gmail.com>
Date: Tue, 28 Oct 2014 10:31:51 -0700
In-Reply-To: <544F9D7D.40301@gmail.com> (Michael Kerrisk's message of "Tue, 28
	Oct 2014 14:43:25 +0100")
Message-ID: <87r3xscd88.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+edamRnWXKpn66nHRFT6XBwqtC0PrdU6Q=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0669]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Michael Kerrisk \(man-pages\)" <mtk.manpages@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 238 ms - load_scoreonly_sql: 0.04 (0.0%),
	signal_user_changed: 3.4 (1.4%), b_tie_ro: 2.5 (1.1%), parse: 0.53 (0.2%),
	extract_message_metadata: 1.61 (0.7%), get_uri_detail_list: 0.42 (0.2%),
	tests_pri_-1000: 3.0 (1.2%), tests_pri_-950: 1.00 (0.4%), tests_pri_-900:
	0.81 (0.3%), tests_pri_-400: 13 (5.3%), check_bayes: 12 (5.0%), b_tokenize:
	3.0 (1.3%), b_tok_get_all: 4.1 (1.7%), b_comp_prob: 1.24 (0.5%),
	b_tok_touch_all: 1.76 (0.7%), b_finish: 0.60 (0.3%), tests_pri_0: 204 (85.6%),
	 tests_pri_500: 4.0 (1.7%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH] umount.2: Correct the description of MNT_DETACH
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:

> Hi Eric,
>
> I'm still hoping for a revised patch from you in the light
> of Andy's comments and question.

Andy's concerns are orthogonal to my original patch, and
actually have nothing to do with MNT_DETACH.

Which was my point but here I will send a second patch on top of my
first patch to document the effect of shared mounts in umount.2

Eric
