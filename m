Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759873AbaKASYS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 14:24:18 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:58253 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758469AbaKASYP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 14:24:15 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20141101150620.GP7996@ZenIV.linux.org.uk>
References: <20141013062945.GX7996@ZenIV.linux.org.uk> <87r3ybwq0b.fsf@x220.int.ebiederm.org> <20141101083804.GO7996@ZenIV.linux.org.uk> <20141101150620.GP7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8BIT
From: "Eric W.Biederman" <ebiederm@xmission.com>
Date: Sat, 01 Nov 2014 11:23:34 -0700
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <cfb295aa-0e4b-4185-875f-3745d2c5c01a@email.android.com>
X-XM-AID: U2FsdGVkX196Z02UKQ2z8Y5vi5LNZtEoUy0UeI6sKXY=
X-SA-Exim-Connect-IP: 208.54.64.176
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.5 XMGappySubj_01 Very gappy subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5472]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
X-Spam-Timing: total 207 ms - load_scoreonly_sql: 0.04 (0.0%),
	signal_user_changed: 3.6 (1.7%), b_tie_ro: 2.6 (1.3%), parse: 0.76 (0.4%),
	extract_message_metadata: 12 (5.6%), get_uri_detail_list: 0.91 (0.4%),
	tests_pri_-1000: 6 (2.7%), tests_pri_-950: 1.29 (0.6%), tests_pri_-900: 1.09
	(0.5%), tests_pri_-400: 17 (8.2%), check_bayes: 16 (7.7%), b_tokenize: 4.2
	(2.0%), b_tok_get_all: 6 (2.9%), b_comp_prob: 1.77 (0.9%), b_tok_touch_all:
	1.92 (0.9%), b_finish: 0.64 (0.3%), tests_pri_0: 158 (76.6%), tests_pri_500:
	4.4 (2.1%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [RFC] dealing with proc_ns_follow_link() and "namespace" dentries
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On November 1, 2014 8:06:20 AM PDT, Al Viro <viro@ZenIV.linux.org.uk> wrote:
>On Sat, Nov 01, 2014 at 08:38:04AM +0000, Al Viro wrote:
>> OK, interim branch (_completely_ untested, and there's quite a bit of
>> work remaining) is in vfs.git#nsfs.
>
>... except that what got pushed was completely buggered - the last
>changes
>not committed *and* include/linux/ns_common.h not git-add'ed at the
>very
>beginning.  Oh, well - it wasn't hard to reconstruct its history...
>
>Anyway, that much got fixed and pushed; sorry about the noise -
>shouldn't
>have posted before grabbing some sleep...

No worries.  I am effectively without internet access right from now until about the 3rd week in November as I move so I really can't look anyway.

>From your description I am concerned about using the letter combination nsfs.   I once used nsfd, and that was so close to nfsd that Linus got confused, and hilarity ensued.   nsfs isn't quite as bad but the abbreviation still seems close enough to nfs that confusion could result.

Eric
