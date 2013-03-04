Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513Ab3CDEEG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 23:04:06 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:60704 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756420Ab3CDEEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 23:04:02 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Rob Landley <rob@landley.net>
Cc: mtk.manpages@gmail.com, linux-man <linux-man@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
References: <CAKgNAki=mUYuu_Ewhe7sjCmo+Dq2Vr+FZCixqNRaadcvAxtpFw@mail.gmail.com>
	<1362110504.15531.4@driftwood>
	<CAKgNAkgVKnhRT1Lpq4a_UdBKB+tn6XmWSDF2QJXG0aSLtNH6dg@mail.gmail.com>
	<1362369010.29250.3@driftwood>
Date: Sun, 03 Mar 2013 20:03:55 -0800
In-Reply-To: <1362369010.29250.3@driftwood> (Rob Landley's message of "Sun, 03
	Mar 2013 21:50:10 -0600")
Message-ID: <876217olp0.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18jyPZocIBkTIdy3Zjmi66nyPdbhKM24hI=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Rob Landley <rob@landley.net>
X-Spam-Relay-Country: 
Subject: Re: For review: pid_namespaces(7) man page
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley <rob@landley.net> writes:

> On 03/01/2013 03:57:40 AM, Michael Kerrisk (man-pages) wrote:
>> > And yet the glibc guys insist on #define  
>> GNU_GNU_GNU_ALL_HAIL_STALLMAN in
>> > order to access this Linux-specific feature which has nothing  
>> whatsoever to
>> > do with the FSF.
>> 
>> This is a misunderstanding. _GNU_SOURCE is the standard way to expose
>> Linux-specific functionality from POSIX header files.
>
> What standard? The Linux kernel is not, and never was, part of the GNU  
> project.

Is the argument that there should be a _LINUX_SOURCE directive in glibc
for this?

Although come to think of it I can't imagine how <sched.h> is a POSIX
header.  Last I looked it only had linux specific bits in it.  Which
makes needing any kind of #define strange.

Eric

