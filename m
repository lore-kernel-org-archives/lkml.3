Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932593Ab3BMSoK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:44:10 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:57337 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab3BMSoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:44:08 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: linux-fsdevel@vger.kernel.org
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>
References: <87621w14vs.fsf@xmission.com>
	<1360777934-5663-1-git-send-email-ebiederm@xmission.com>
	<1360777934-5663-18-git-send-email-ebiederm@xmission.com>
	<20130213181450.GJ30800@cs.cmu.edu>
Date: Wed, 13 Feb 2013 10:44:01 -0800
In-Reply-To: <20130213181450.GJ30800@cs.cmu.edu> (Jan Harkes's message of
	"Wed, 13 Feb 2013 13:14:51 -0500")
Message-ID: <87ip5wvytq.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/XsZct1CrKOkKS/hpGO5sz0iy9fymp92s=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 XMDrug1234561 Drug references
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0133]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;linux-fsdevel@vger.kernel.org
X-Spam-Relay-Country: 
Subject: Re: [PATCH review 18/85] coda: Restrict coda messages to the initial user namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Harkes <jaharkes@cs.cmu.edu> writes:

> On Wed, Feb 13, 2013 at 09:51:07AM -0800, Eric W. Biederman wrote:
>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>> 
>> Remove the slight chance that uids and gids in coda messages will be
>> interpreted in the wrong user namespace.
>
> Awesome, I was wondering how to handle uid's from different namespaces
> cleanly in Coda's userspace daemon without resorting to exporting kuids
> to userspace.
>
> But this is a much more elegant solution, every namespace that cares
> about Coda should just run their own mountpoint and userspace daemon.

Do you know if people care enough about coda that they will want to
export run coda multiple mountpoint and userspace daemons?

I have never seen anyone running coda so I was suspecting that coda was
a filesystem that was gradually fading away.

Eric

