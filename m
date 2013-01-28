Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487Ab3A1RS7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 12:18:59 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:34397 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757007Ab3A1RS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 12:18:56 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Lord Glauber Costa of Sealand <glommer@parallels.com>
Cc: <linux-fsdevel@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, Michael Kerrisk <mtk@lwn.net>
References: <87ehh8it9s.fsf@xmission.com> <87txq4hedl.fsf@xmission.com>
	<51062AB5.9060203@parallels.com> <51062DA8.1060804@parallels.com>
	<87k3qxu3kp.fsf@xmission.com> <51063558.1010402@parallels.com>
	<87k3qxs2ko.fsf@xmission.com> <5106A941.6060403@parallels.com>
Date: Mon, 28 Jan 2013 09:18:42 -0800
In-Reply-To: <5106A941.6060403@parallels.com> (Lord Glauber Costa of Sealand's
	message of "Mon, 28 Jan 2013 20:37:21 +0400")
Message-ID: <874ni1ql8t.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+HJobrlZqbYqhYKFsWEOc+gN+CUbwb96k=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0043]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Lord Glauber Costa of Sealand <glommer@parallels.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH review 3/6] userns: Recommend use of memory control groups.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lord Glauber Costa of Sealand <glommer@parallels.com> writes:

>> For two pieces of software that were designed to complement each other
>> I find it a bit surprising how many people (including myself) need the
>> connection made that memory control groups and user namespaces should go
>> together.
>
> Well, I've manifested many times in here that I am less than satisfied
> about the fact that the connection between namespaces and cgroups are so
> loose. There are many situations, like virtualizing the proc files and
> friends where I believe we could benefit from having the information
> about whether or not cgroups and namespaces are used at the same time.

Certainly there are issues where there are not good ways for
applications to discover how much memory or how many cpus are available
for the application to run on.  And applications resort to looking at
how much memory or how many cpus are in the box.

The only way I can think of to make things better is to provide good
alternatives that people can look at and make limiting applications
common enough that the bugs start getting fixed.  And possibly doing the
work to fix a common library or two.

Eric

