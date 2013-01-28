Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045Ab3A1Qef (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 11:34:35 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:51476 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab3A1Qec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 11:34:32 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Vasily Kulikov <segoon@openwall.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <87ehh8it9s.fsf@xmission.com> <877gn0it3t.fsf@xmission.com>
	<20130128145144.GA4677@cachalot>
Date: Mon, 28 Jan 2013 08:34:20 -0800
In-Reply-To: <20130128145144.GA4677@cachalot> (Vasily Kulikov's message of
	"Mon, 28 Jan 2013 18:51:44 +0400")
Message-ID: <87vcahqnar.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX193dagko13kBU2i1BzK9POUaB/vf9Vcafs=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Vasily Kulikov <segoon@openwall.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH review 1/6] userns: Avoid recursion in put_user_ns
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vasily Kulikov <segoon@openwall.com> writes:

> Acked-by: Vasily Kulikov <segoon@openwall.com>
>
> The second bug I've noted in the same email (OOM) looks like should be
> "fixed" by using memcg to limit kernel memory.  So, I'm fine with this
> side of user_ns :)

Good.  That is what it looked like from here.

You pointed out one or two other things that I am still thinking about.

Eric

