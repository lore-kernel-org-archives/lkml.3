Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbbAGXat (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 18:30:49 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:38065 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378AbbAGXa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 18:30:28 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Tejun Heo <tj@kernel.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Richard Weinberger <richard@nod.at>,
        Linux API <linux-api@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        cgroups mailinglist <cgroups@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>
References: <87lhlgpyxk.fsf@x220.int.ebiederm.org>
	<CAGr1F2HSi_D07r2c5CKOsjSR1+58k9G2MrtACsd+HV6XKvJ7cA@mail.gmail.com>
	<54AB2992.6060707@nod.at>
	<CAGr1F2EGOUSEd3-G4PS0mq=9kU1nWG4CwHUOQaNUATepc11_Sw@mail.gmail.com>
	<54ACFC38.5070007@nod.at> <87fvbmir9q.fsf@x220.int.ebiederm.org>
	<20150107193059.GA1857@mail.hallyn.com>
	<87bnma6xwv.fsf@x220.int.ebiederm.org>
	<20150107224430.GA28414@htj.dyndns.org>
	<878uhe42km.fsf@x220.int.ebiederm.org>
	<20150107230615.GA28630@htj.dyndns.org>
	<87fvbm2nni.fsf@x220.int.ebiederm.org>
Date: Wed, 07 Jan 2015 17:27:38 -0600
In-Reply-To: <87fvbm2nni.fsf@x220.int.ebiederm.org> (Eric W. Biederman's
	message of "Wed, 07 Jan 2015 17:09:53 -0600")
Message-ID: <87y4peyxw5.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18UVVCxBVlu/XQaZbzVw0VtxRirzFjU8Mg=
X-SA-Exim-Connect-IP: 97.121.85.189
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Tejun Heo <tj@kernel.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 167 ms - load_scoreonly_sql: 0.04 (0.0%),
	signal_user_changed: 2.7 (1.6%), b_tie_ro: 1.99 (1.2%), parse: 0.58 (0.3%),
	extract_message_metadata: 9 (5.5%), get_uri_detail_list: 0.83 (0.5%),
	tests_pri_-1000: 4.7 (2.8%), tests_pri_-950: 1.01 (0.6%), tests_pri_-900:
	0.83 (0.5%), tests_pri_-400: 18 (10.6%), check_bayes: 17 (10.0%), b_tokenize:
	4.7 (2.8%), b_tok_get_all: 6 (3.7%), b_comp_prob: 1.70 (1.0%),
	b_tok_touch_all: 2.4 (1.4%), b_finish: 0.59 (0.4%), tests_pri_0: 123 (73.8%),
	tests_pri_500: 4.7 (2.8%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCHv3 8/8] cgroup: Add documentation for cgroup namespaces
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ebiederm@xmission.com (Eric W. Biederman) writes:

> Tejun Heo <tj@kernel.org> writes:
>
>> On Wed, Jan 07, 2015 at 05:02:17PM -0600, Eric W. Biederman wrote:
>>> Ignoring namespace details for a moment. The following should be
>>> possible with a unified hierarchy.  If it is not it is a show stopper
>>> of a regression.
>>
>> The -o SUBSYS option doesn't exist.  Jesus, at least get yourself
>> familiar with the basics before claiming random stuff.

Oh let's see I got that command line option out of /proc/mounts and yes
it works.  Perhaps it doesn't if I invoke unified hiearchies but the
option does in fact exist and work.

Now I really do need to test report regressions, and send probably send
regression fixes.  If I understand your strange ranting I think you just
told me that option that -o SUBSYS does work with unified hierarchies.

Tejun.  I asked you specifically about this case 2 years ago at plumbers
and you personally told me this would continue to work.  I am going to
hold you to that.

Fixing bugs is one thing.  Gratuitious regressions that make supporting
existing user space applications insane is another.

Eric



