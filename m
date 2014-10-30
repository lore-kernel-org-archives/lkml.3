Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbaJ3EF5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 00:05:57 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:56049 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaJ3EFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 00:05:54 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org, arnd@arndb.de, tj@kernel.org,
        marcel@holtmann.org, desrt@desrt.ca, hadess@hadess.net,
        dh.herrmann@gmail.com, tixxdz@opendz.org,
        simon.mcvittie@collabora.co.uk, daniel@zonque.org,
        alban.crequy@collabora.co.uk, javier.martinez@collabora.co.uk,
        teg@jklm.no, Andy Lutomirski <luto@amacapital.net>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
	<20141029221505.GA7812@kroah.com>
Date: Wed, 29 Oct 2014 21:04:58 -0700
In-Reply-To: <20141029221505.GA7812@kroah.com> (Greg KH's message of "Wed, 29
	Oct 2014 15:15:05 -0700")
Message-ID: <87egtqurrp.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19n31gKZsOvDXe5g/8vylnCJEmk+Z6H4mY=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4993]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Greg KH <gregkh@linuxfoundation.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 420 ms - load_scoreonly_sql: 0.07 (0.0%),
	signal_user_changed: 3.7 (0.9%), b_tie_ro: 2.6 (0.6%), parse: 1.12 (0.3%),
	extract_message_metadata: 23 (5.6%), get_uri_detail_list: 1.48 (0.4%),
	tests_pri_-1000: 10 (2.4%), tests_pri_-950: 2.1 (0.5%), tests_pri_-900: 1.77
	(0.4%), tests_pri_-400: 28 (6.6%), check_bayes: 26 (6.1%), b_tokenize: 9
	(2.2%), b_tok_get_all: 7 (1.7%), b_comp_prob: 3.4 (0.8%), b_tok_touch_all:
	2.3 (0.5%), b_finish: 0.86 (0.2%), tests_pri_0: 336 (80.1%), tests_pri_500: 8
	(1.9%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 00/12] Add kdbus implementation
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> writes:

> On Wed, Oct 29, 2014 at 03:00:44PM -0700, Greg Kroah-Hartman wrote:
>> kdbus is a kernel-level IPC implementation that aims for resemblance to
>> the the protocol layer with the existing userspace D-Bus daemon while
>> enabling some features that couldn't be implemented before in userspace.
>
> {sigh}
>
> I'll blame it on the jet-lag for the lack of [XX/12] markings on the
> patches.  I'll give it a day for review before resending if people
> really want to know the ordering.  It doesn't matter except for the
> final patch that adds the code to the build file.
>
> sorry about that,

For what it is worth these patches are also poorly split up.  Every
patch I looked at in detail had functions that were being introduced
that did not have callers.

That poor split up of the patches makes it difficult to see how
the functionality that is being introduced is being used.

Eric
