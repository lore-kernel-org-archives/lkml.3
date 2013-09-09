Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab3IIGmO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 02:42:14 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:39133 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab3IIGmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 02:42:13 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Christian Kujau <lists@nerdbynature.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Vasiliy Kulikov <segoon@openwall.com>
References: <alpine.DEB.2.11.1309070133340.21301@trent.utfs.org>
Date: Sun, 08 Sep 2013 23:42:05 -0700
In-Reply-To: <alpine.DEB.2.11.1309070133340.21301@trent.utfs.org> (Christian
	Kujau's message of "Sat, 7 Sep 2013 01:51:16 -0700 (PDT)")
Message-ID: <87r4cybio2.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18AybCAl3Fw0LVckueffrxzDXBp55q+s+o=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0827]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.0 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
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

> Hi,
>
> I was wondering why I cannot see processes that were started from SGID 
> programs:

I don't have a clue why anyone would want to hide processes, and make
their own lives more difficult.

The check with hidepid is can you ptrace the process.  I expect there
is something with those sgid processes that keeps you from ptracing
them.

Of course if you don't like the silly behavior you can always disable
it.

Eric
