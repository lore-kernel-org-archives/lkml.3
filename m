Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060AbaLLV5K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 16:57:10 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:34182 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbaLLV5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 16:57:06 -0500
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
Date: Fri, 12 Dec 2014 15:54:47 -0600
In-Reply-To: <878uicy1r9.fsf_-_@x220.int.ebiederm.org> (Eric W. Biederman's
	message of "Fri, 12 Dec 2014 15:52:26 -0600")
Message-ID: <87ppbo1ql4.fsf_-_@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+LGutVCN78q29TayMfwFxQHWLSGDEvU/0=
X-SA-Exim-Connect-IP: 67.3.210.55
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  0.7 XMSubLong Long Subject
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Michael Kerrisk-manpages <mtk.manpages@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 475 ms - load_scoreonly_sql: 0.09 (0.0%),
	signal_user_changed: 3.8 (0.8%), b_tie_ro: 2.4 (0.5%), parse: 2.1 (0.4%),
	extract_message_metadata: 25 (5.3%), get_uri_detail_list: 3.7 (0.8%),
	tests_pri_-1000: 15 (3.1%), tests_pri_-950: 2.4 (0.5%), tests_pri_-900: 1.63
	(0.3%), tests_pri_-400: 40 (8.4%), check_bayes: 38 (8.1%), b_tokenize: 17
	(3.5%), b_tok_get_all: 9 (1.9%), b_comp_prob: 4.3 (0.9%), b_tok_touch_all:
	3.9 (0.8%), b_finish: 2.2 (0.5%), tests_pri_0: 372 (78.4%), tests_pri_500: 6
	(1.3%), rewrite_mail: 0.00 (0.0%)
Subject: [PATCH 2/2] user_namespaces.7: Update the documention to reflect the fixes for negative groups
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Files with access permissions such as ---rwx---rwx give fewer
permissions to their group then they do to everyone else.  Which means
dropping groups with setgroups(0, NULL) actually grants a process
privileges.

The uprivileged setting of gid_map turned out not to be safe after
this change.  Privilege setting of gid_map can be interpreted as
meaning yes it is ok to drop groups.

To prevent this problem and future problems user namespaces were
changed in such a way as to guarantee a user can not obtain
credentials without privilege they could not obtain without the
help of user namespaces.

This meant testing the effective user ID and not the filesystem user
ID as setresuid and setregid allow setting any process uid or gid
(except the supplemental groups) to the effective ID.

Furthermore to preserve in some form the useful applications that have
been setting gid_map without privilege the file /proc/[pid]/setgroups
was added to allow disabling setgroups.  With the setgroups system
call permanently disabled in a user namespace it again becomes safe to
allow writes to gid_map without privilege.

Here is my meager attempt to update user_namespaces.7 to reflect these
issues.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 man7/user_namespaces.7 | 52 +++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 49 insertions(+), 3 deletions(-)

diff --git a/man7/user_namespaces.7 b/man7/user_namespaces.7
index d76721d9a0a1..f8333a762308 100644
--- a/man7/user_namespaces.7
+++ b/man7/user_namespaces.7
@@ -533,11 +533,16 @@ One of the following is true:
 The data written to
 .I uid_map
 .RI ( gid_map )
-consists of a single line that maps the writing process's filesystem user ID
+consists of a single line that maps the writing process's effective user ID
 (group ID) in the parent user namespace to a user ID (group ID)
 in the user namespace.
-The usual case here is that this single line provides a mapping for user ID
-of the process that created the namespace.
+The writing process must have the same effective user ID as the process
+that created the user namespace.
+In the case of
+.I gid_map
+the
+.I setgroups
+file must have been written to earlier and disabled the setgroups system call.
 .IP * 3
 The opening process has the
 .BR CAP_SETUID
@@ -552,6 +557,47 @@ Writes that violate the above rules fail with the error
 .\"
 .\" ============================================================
 .\"
+.SS Interaction with system calls that change the uid or gid values
+When in a user namespace where the
+.I uid_map
+or
+.I gid_map
+file has not been written the system calls that change user IDs
+or group IDs respectively will fail.  After the
+.I uid_map
+and
+.I gid_map
+file have been written only the mapped values may be used in
+system calls that change user IDs and group IDs.
+
+For user IDs these system calls include
+.BR setuid ,
+.BR setfsuid ,
+.BR setreuid ,
+and
+.BR setresuid .
+
+For group IDs these system calls include
+.BR setgid ,
+.BR setfsgid ,
+.BR setregid ,
+.BR setresgid ,
+and
+.BR setgroups.
+
+Writing
+.BR deny
+to the
+.I /proc/[pid]/setgroups
+file before writing to
+.I /proc/[pid]/gid_map
+will permanently disable the setgroups system call in a user namespace
+and allow writing to
+.I /proc/[pid]/gid_map
+without
+.BR CAP_SETGID
+in the parent user namespace.
+
 .SS Unmapped user and group IDs
 .PP
 There are various places where an unmapped user ID (group ID)
-- 
1.9.1

