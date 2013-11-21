Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213Ab3KUWqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 17:46:10 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:48542 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab3KUWqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 17:46:06 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Aditya Kali <adityakali@google.com>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1382737870-12792-1-git-send-email-adityakali@google.com>
	<20131029153610.GB32008@mail.hallyn.com> <87a9heqwkg.fsf@xmission.com>
	<20131121215035.GA9773@mail.hallyn.com>
Date: Thu, 21 Nov 2013 14:46:00 -0800
In-Reply-To: <20131121215035.GA9773@mail.hallyn.com> (Serge E. Hallyn's
	message of "Thu, 21 Nov 2013 21:50:35 +0000")
Message-ID: <87r4a974rb.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18PmnE45LkH8Z4fK6uo+aj8ulMoXqURUuY=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0030]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serge@hallyn.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] proc: Fix namespace mountpoint path in /proc/mounts
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> Aditya, is this something you'd have time to write a patch for?

I have a tested patch that fixes when we call ns_dname.  Give me a day
and I will push out my pending pile of fixes for review.

Eric
