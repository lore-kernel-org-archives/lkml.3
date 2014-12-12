Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549AbaLLV4X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 16:56:23 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:33979 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbaLLV4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 16:56:20 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Michael Kerrisk-manpages <mtk.manpages@gmail.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Linux API <linux-api@vger.kernel.org>,
        linux-man <linux-man@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Richard Weinberger <richard@nod.at>,
        Kenton Varda <kenton@sandstorm.io>, stable <stable@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
References: <52e0643bd47b1e5c65921d6e00aea1f724bb510a.1417281801.git.luto@amacapital.net>
	<87a935u3nj.fsf@x220.int.ebiederm.org>
	<CALCETrXkEOiyzpvqtXtk1f4sL+M1Q-Y6rV=K91ez3yv2nb4Y0Q@mail.gmail.com>
	<87388xodlj.fsf@x220.int.ebiederm.org>
	<CALCETrXWx2-ZejEHmOi7aSoF-qJMRGR5yseeMhuurZwJRrQbUg@mail.gmail.com>
	<87h9x5re41.fsf_-_@x220.int.ebiederm.org>
	<87mw6xpzb0.fsf_-_@x220.int.ebiederm.org>
	<CALCETrU-o5mPr1jCaLXDuuF6J2N470zAtx=8Fa-SjF=ZpdE8mQ@mail.gmail.com>
	<87ppbtn4mv.fsf@x220.int.ebiederm.org>
	<CALCETrXSScp77BUJR5NSTh5-RnEZ9rqELSGJBeEzgdQ-OtohuQ@mail.gmail.com>
	<87a92xn2io.fsf@x220.int.ebiederm.org>
	<87r3w8liw4.fsf@x220.int.ebiederm.org>
	<87iohklfvj.fsf_-_@x220.int.ebiederm.org>
	<87fvcok11h.fsf_-_@x220.int.ebiederm.org>
	<CALCETrVfKiXuY=KY_=nHpkTyLWgpy_3DK=4Mr2mhpyX9z1TzrA@mail.gmail.com>
	<971ad3f6-90fd-4e3f-916c-8988af3c826d@email.android.com>
	<CALCETrWpzvNm=fjOa3_+4QOqYP8qZUJvQAd6AsRZ71xyHZQRCg@mail.gmail.com>
	<87wq5zf83t.fsf@x220.int.ebiederm.org>
	<87iohh3c9c.fsf@x220.int.ebiederm.org>
	<8761dh3b7k.fsf_-_@x220.int.ebiederm.org>
	<878uicy1r9.fsf_-_@x220.int.ebiederm.org>
Date: Fri, 12 Dec 2014 15:54:01 -0600
Message-ID: <87vblg1qme.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/1CtXvlHLeGmvffahclInDBiUiHBTu2H8=
X-SA-Exim-Connect-IP: 67.3.210.55
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Michael Kerrisk-manpages <mtk.manpages@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 633 ms - load_scoreonly_sql: 0.03 (0.0%),
	signal_user_changed: 3.1 (0.5%), b_tie_ro: 2.2 (0.4%), parse: 0.75 (0.1%),
	extract_message_metadata: 11 (1.7%), get_uri_detail_list: 0.87 (0.1%),
	tests_pri_-1000: 6 (1.0%), tests_pri_-950: 1.28 (0.2%), tests_pri_-900: 1.10
	(0.2%), tests_pri_-400: 19 (2.9%), check_bayes: 17 (2.8%), b_tokenize: 6
	(0.9%), b_tok_get_all: 6 (0.9%), b_comp_prob: 1.51 (0.2%), b_tok_touch_all:
	2.5 (0.4%), b_finish: 0.67 (0.1%), tests_pri_0: 582 (91.9%), tests_pri_500: 6
	(0.9%), rewrite_mail: 0.00 (0.0%)
Subject: [PATCH 1/2] proc.5: Document /proc/[pid]/setgroups
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 man5/proc.5 | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/man5/proc.5 b/man5/proc.5
index 96077d0dd195..d661e8cfeac9 100644
--- a/man5/proc.5
+++ b/man5/proc.5
@@ -1097,6 +1097,21 @@ are not available if the main thread has already terminated
 .\"       Added in 2.6.9
 .\"       CONFIG_SCHEDSTATS
 .TP
+.IR /proc/[pid]/setgroups " (since Linux 3.19-rc1)"
+This file reports
+.BR allow
+if the setgroups system call is allowed in the current user namespace.
+This file reports
+.BR deny
+if the setgroups system call is not allowed in the current user namespace.
+This file may be written to with values of
+.BR allow
+and
+.BR deny
+before
+.IR /proc/[pid]/gid_map
+is written to (enabling setgroups) in a user namespace.
+.TP
 .IR /proc/[pid]/smaps " (since Linux 2.6.14)"
 This file shows memory consumption for each of the process's mappings.
 (The
-- 
1.9.1

