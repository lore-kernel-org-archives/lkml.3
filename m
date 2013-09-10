Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751326Ab3IJKCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 06:02:40 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:58441 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab3IJKCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 06:02:39 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Christian Kujau <lists@nerdbynature.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Vasiliy Kulikov <segoon@openwall.com>
References: <alpine.DEB.2.11.1309070133340.21301@trent.utfs.org>
	<87r4cybio2.fsf@xmission.com>
	<alpine.DEB.2.11.1309100124020.6509@trent.utfs.org>
Date: Tue, 10 Sep 2013 03:00:31 -0700
In-Reply-To: <alpine.DEB.2.11.1309100124020.6509@trent.utfs.org> (Christian
	Kujau's message of "Tue, 10 Sep 2013 01:30:28 -0700 (PDT)")
Message-ID: <87ioy90zeo.fsf@tw-ebiederman.twitter.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+Gsqfj7tihcmKkY2aq/Z8WMZWx0u4nS0g=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1861]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.0 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Christian Kujau <lists@nerdbynature.de>
X-Spam-Relay-Country: 
Subject: Re: proc hidepid=2 and SGID programs
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Kujau <lists@nerdbynature.de> writes:

> On Sun, 8 Sep 2013 at 23:42, Eric W. Biederman wrote:
>> The check with hidepid is can you ptrace the process.  I expect there
>> is something with those sgid processes that keeps you from ptracing
>> them.
>
> Indeed, I cannot strace the process. But still, I wonder if this is 
> intended behaviour.

Well it is acting as desgined so I assume it is intended.

Beyond that shrug.

Eric


