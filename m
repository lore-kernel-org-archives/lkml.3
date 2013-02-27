Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758791Ab3B0XO5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 18:14:57 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:55246 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758444Ab3B0XO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 18:14:56 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: "Raphael S.Carvalho" <raphael.scarv@gmail.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org
References: <1361989929-1145-1-git-send-email-raphael.scarv@gmail.com>
	<20130227200907.GA19205@sergelap>
Date: Wed, 27 Feb 2013 15:14:38 -0800
In-Reply-To: <20130227200907.GA19205@sergelap> (Serge Hallyn's message of
	"Wed, 27 Feb 2013 14:09:07 -0600")
Message-ID: <87txoxbb8h.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1864OaeA1FQHlqzETfAUnh50qorzNwrN4s=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Serge Hallyn <serge.hallyn@ubuntu.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 1/1] kernel/nsproxy.c: Improving a snippet of code.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge Hallyn <serge.hallyn@ubuntu.com> writes:

> Quoting Raphael S.Carvalho (raphael.scarv@gmail.com):
>> It seems GCC generates a better code in that way, so I changed that statement.
>> Btw, they have the same semantic, so I'm sending this patch due to performance issues.
>> 
>> Signed-off-by: Raphael S.Carvalho <raphael.scarv@gmail.com>
>
> Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>

Thanks all.  Added to my development tree. I will push it out in my
for-next branch after 3.9-rc1 is released.

Eric
