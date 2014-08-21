Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412AbaHUN7r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 09:59:47 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:47882 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884AbaHUN7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 09:59:45 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Richard Weinberger <richard@nod.at>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "libvir-list\@redhat.com" <libvir-list@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>
References: <87fvhav3ic.fsf@x220.int.ebiederm.org>
	<CAFLxGvwi-iJRyfwv8v9fcRkiSu2d-az8W55xMPbp_d8wQKmwjg@mail.gmail.com>
	<87vbpm4f4y.fsf@x220.int.ebiederm.org> <53F591E7.3010509@nod.at>
	<53F59EC7.6060107@nod.at>
Date: Thu, 21 Aug 2014 08:54:57 -0500
In-Reply-To: <53F59EC7.6060107@nod.at> (Richard Weinberger's message of "Thu,
	21 Aug 2014 09:24:55 +0200")
Message-ID: <87zjeyvtfy.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18q2Fn5FAHCOzU7FgXE2BKDYp0NghGYdlQ=
X-SA-Exim-Connect-IP: 107.0.249.3
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4678]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.0 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Richard Weinberger <richard@nod.at>
X-Spam-Relay-Country: 
Subject: Re: [GIT PULL] namespace updates for v3.17-rc1
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger <richard@nod.at> writes:

> Am 21.08.2014 08:29, schrieb Richard Weinberger:
>> Am 21.08.2014 06:53, schrieb Eric W. Biederman:
>>> The bugs fixed are security issues, so if we have to break a small
>>> number of userspace applications we will.  Anything that we can
>>> reasonably do to avoid regressions will be done.
>>>
>>> Could you please look at my user-namespace.git#for-next branch I have a
>>> fix for at least one regresion causing issue in there.  I think it may
>>> fix your issues but I am not fully certain more comments below.
>> 
>> I'll run this on my LXC testbed today.
>
> Looks good. With these patches applied libvirt works again. :)

Darn I read my email in the wrong order.  I am glad to hear that my
changes were enough to fix libvirt-lxc.

I will aim at pushing this to Linus after the conference is over and I
can trust myself to think clearly.

Eric
