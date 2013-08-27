Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab3H0BEI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:04:08 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:41619 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab3H0BEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:04:05 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Miller <davem@davemloft.net>
Cc: luto@amacapital.net, security@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <cover.1377196394.git.luto@amacapital.net>
	<20130826.155909.1859861206590524940.davem@davemloft.net>
Date: Mon, 26 Aug 2013 18:03:57 -0700
In-Reply-To: <20130826.155909.1859861206590524940.davem@davemloft.net> (David
	Miller's message of "Mon, 26 Aug 2013 15:59:09 -0400 (EDT)")
Message-ID: <87sixwlzb6.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/D8mh28RLsOEYLmENlAlA2nNLtdvmI8I0=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0072]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa08 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa08 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;David Miller <davem@davemloft.net>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 0/2] Rename nsproxy.pid_ns and fix a related security bug
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: Andy Lutomirski <luto@amacapital.net>
> Date: Thu, 22 Aug 2013 11:39:14 -0700
>
>>     commit 92f28d973cce45ef5823209aab3138eb45d8b349
>>     Author: Eric W. Biederman <ebiederm@xmission.com>
>>     Date:   Fri Mar 15 01:03:33 2013 -0700
>> 
>>         scm: Require CAP_SYS_ADMIN over the current pidns to spoof pids.
>> 
>> Eric fell for my bogus claim that nsproxy->pid_ns was the current'
>> process's pid ns.  This isn't true.
>> 
>> Let's fix the bug and rename pid_ns so that no one gets this wrong again.
>> 
>> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>
> Eric please take the time to review these changes, thanks.

Reviewed they are good.

My apologies for the delay life got in my way and I fell behind on
dealing with patches.

Eric


