Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbaDYWjl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 18:39:41 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:52213 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbaDYWjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 18:39:10 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Dmitry Kasatkin <d.kasatkin@samsung.com>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        John Johansen <john.johansen@canonical.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>, viro@zeniv.linux.org.uk,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel-team <kernel-team@lists.ubuntu.com>
References: <535A5C78.1070901@samsung.com> <535A75C1.3050901@samsung.com>
	<20140425182310.GA9128@redhat.com>
	<87sip15iy5.fsf@x220.int.ebiederm.org>
	<20140425192543.GA11908@redhat.com>
	<878uqt42q7.fsf@x220.int.ebiederm.org>
	<20140425200156.GA13727@redhat.com>
	<CACE9dm9gs64C9JfSYKboUOwT_uXC7Ha1kuXsMWOE-0isQuzfmg@mail.gmail.com>
	<874n1h16le.fsf@x220.int.ebiederm.org>
	<CACE9dm_56FvbJDVyxvTtd3yL+d89XYhZ-i038HJS-sUsZAPpaQ@mail.gmail.com>
	<87iopxxfpp.fsf@x220.int.ebiederm.org>
	<CACE9dm-fdqDgFT5Pw1ry6XOuAhqmsEEiQMOFw=rooazBkdx-wg@mail.gmail.com>
	<CACE9dm9CTU0-FFr3KveE8QV0dR-vxiDg91Km_2w3v37O5eTcYg@mail.gmail.com>
Date: Fri, 25 Apr 2014 15:38:34 -0700
In-Reply-To: <CACE9dm9CTU0-FFr3KveE8QV0dR-vxiDg91Km_2w3v37O5eTcYg@mail.gmail.com>
	(Dmitry Kasatkin's message of "Sat, 26 Apr 2014 00:56:32 +0300")
Message-ID: <87lhutt4ph.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19BiM8l1KqMpBElRzCNrz//uVU5/zWthn4=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3131]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: Kernel panic at Ubuntu: IMA + Apparmor
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Kasatkin <dmitry.kasatkin@gmail.com> writes:

> Is it really a show stopper to switch order of 2 functions as quick fix?
> It was like that before 3.10 and seemed ok...

When that is the question.  The answer is yes it is a show stopper.

A quick fix to bury a fundamental design flaw because the code
previously seemed ok.  That seems fundamentally wrong.

Having IMA conflict with Apparmor in Kconfig would be a sensible quick
fix.

Eric
