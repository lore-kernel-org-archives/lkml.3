Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751004AbaLOUOj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 15:14:39 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:43520 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbaLOUOg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 15:14:36 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: =?utf-8?Q?St=C3=A9phane?= Graber <stgraber@ubuntu.com>,
        Richard Weinberger <richard@nod.at>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-man <linux-man@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Linux API <linux-api@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>, stable <stable@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kenton Varda <kenton@sandstorm.io>,
        LSM <linux-security-module@vger.kernel.org>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <87ppbtn4mv.fsf@x220.int.ebiederm.org>
	<CALCETrXSScp77BUJR5NSTh5-RnEZ9rqELSGJBeEzgdQ-OtohuQ@mail.gmail.com>
	<87a92xn2io.fsf@x220.int.ebiederm.org>
	<87r3w8liw4.fsf@x220.int.ebiederm.org>
	<87iohklfvj.fsf_-_@x220.int.ebiederm.org>
	<87mw6vh31e.fsf_-_@x220.int.ebiederm.org>
	<20141210224822.GG20012@ubuntumail>
	<87lhmcy2et.fsf@x220.int.ebiederm.org>
	<20141212220840.GF22091@castiana.ipv6.teksavvy.com>
	<8761dgze56.fsf@x220.int.ebiederm.org>
	<20141215193838.GB28375@ubuntumail>
Date: Mon, 15 Dec 2014 14:11:59 -0600
In-Reply-To: <20141215193838.GB28375@ubuntumail> (Serge Hallyn's message of
	"Mon, 15 Dec 2014 19:38:38 +0000")
Message-ID: <8761dcwu40.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-AID: U2FsdGVkX1+AeeaEgkMjTQQyac+kgmeEEd4i5BzMu04=
X-SA-Exim-Connect-IP: 97.121.85.189
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Serge Hallyn <serge.hallyn@ubuntu.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 13291 ms - load_scoreonly_sql: 0.03 (0.0%),
	signal_user_changed: 4.3 (0.0%), b_tie_ro: 3.3 (0.0%), parse: 1.36 (0.0%),
	extract_message_metadata: 16 (0.1%), get_uri_detail_list: 2.1 (0.0%),
	tests_pri_-1000: 6 (0.0%), tests_pri_-950: 1.40 (0.0%), tests_pri_-900: 1.11
	(0.0%), tests_pri_-400: 28 (0.2%), check_bayes: 26 (0.2%), b_tokenize: 8
	(0.1%), b_tok_get_all: 10 (0.1%), b_comp_prob: 3.0 (0.0%), b_tok_touch_all:
	2.7 (0.0%), b_finish: 0.64 (0.0%), tests_pri_0: 297 (2.2%), tests_pri_500:
	12932 (97.3%), poll_dns_idle: 12916 (97.2%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [CFT] Can I get some Tested-By's on this series?
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge Hallyn <serge.hallyn@ubuntu.com> writes:

> Quoting Eric W. Biederman (ebiederm@xmission.com):
>> Stéphane Graber <stgraber@ubuntu.com> writes:
>> 
>> > On Fri, Dec 12, 2014 at 03:38:18PM -0600, Eric W. Biederman wrote:
>> >> Serge Hallyn <serge.hallyn@ubuntu.com> writes:
>> >> 
>> >> > Quoting Eric W. Biederman (ebiederm@xmission.com):
>> >> >> 
>> >> >> Will people please test these patches with their container project?
>> >> >> 
>> >> >> These changes break container userspace (hopefully in a minimal way) if
>> >> >> I could have that confirmed by testing I would really appreciate it.  I
>> >> >> really don't want to send out a bug fix that accidentally breaks
>> >> >> userspace again.
>> >> >> 
>> >> >> The only issue sort of under discussion is if there is a better name for
>> >> >> /proc/<pid>/setgroups, and the name of the file will not affect the
>> >> >> functionality of the patchset.
>> >> >> 
>> >> >> With the code reviewed and written in simple obviously correct, easily
>> >> >> reviewable ways I am hoping/planning to send this to Linus ASAP.
>> >> >> 
>> >> >> Eric
>> >> >
>> >> > Is there a git tree we can clone?
>> >> 
>> >> Have either of you been able to check to see if any of my changes
>> >> affects lxc?
>> >> 
>> >> I am trying to gauge how hard and how fast I should push to Linus.  lxc
>> >> being the largest adopter of unprivileged user namespaces for general
>> >> purpose containers.
>> >> 
>> >> I expect you just call newuidmap and newgidmap and don't actually care
>> >> about not being able to set gid_map without privilege.  But I really
>> >> want to avoid pushing a security fix and then being surprised that
>> >> things like lxc break.
>> >> 
>> >> Eric
>> >
>> > Hi Eric,
>> >
>> > I've unfortunately been pretty busy this week as I was (well, still am)
>> > travelling to South Africa for a meeting. I don't have a full kernel
>> > tree around here and a full git clone isn't really doable over the kind
>> > of Internet I've got here :)
>> >
>> > Hopefully Serge can give it a quick try, otherwise I should be able to
>> > do some tests on Tuesday when I'm back home.
>> 
>> I thought Serge was going to but I haven't heard yet so I am prodding ;-)
>
> Ok, thanks - yes, unprivileged lxc is working fine with your kernels.
> Just to be sure I was testing the right thing I also tested using
> my unprivileged nsexec testcases, and they failed on setgroup/setgid
> as now expected, and succeeded there without your patches.

Thanks.

Serge unless you object will add your Tested-By to my pull message to Linus.

Minor question do you runprivileged nsexec test cases test to see if the
write to gid_map succeeds?  I would have expected the gid_map write to
fail before the setgroups setgid system calls came into play.

Eric

