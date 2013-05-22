Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781Ab3EVSEq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 14:04:46 -0400
Received: from www.meduna.org ([92.240.244.38]:50003 "EHLO meduna.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181Ab3EVSEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 14:04:44 -0400
Message-ID: <519D08B0.8050707@meduna.org>
Date: Wed, 22 May 2013 20:04:32 +0200
From: Stanislav Meduna <stano@meduna.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Hai Huang <hhuang@redhat.com>
Subject: Re: [PATCH] mm: fix up a spurious page fault whenever it happens
References: <5195ED8B.7060002@meduna.org> <1369183168.6828.168.camel@gandalf.local.home> <519CBB30.3060200@redhat.com> <CA+55aFxMqvDvcVtLW-yD2PuU_CcjPOC30Zk07Kuk6S25WCzbHQ@mail.gmail.com> <20130522134111.33a695c5@cuia.bos.redhat.com>
In-Reply-To: <20130522134111.33a695c5@cuia.bos.redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Authenticated-User: stano@meduna.org
X-Authenticator: dovecot_plain
X-Spam-Score: -6.9
X-Spam-Score-Int: -68
X-Exim-Version: 4.72 (build at 25-Oct-2012 18:35:58)
X-Date: 2013-05-22 20:04:38
X-Connected-IP: 95.105.165.4:4440
X-Message-Linecount: 40
X-Body-Linecount: 20
X-Message-Size: 1552
X-Body-Size: 409
X-Received-Count: 1
X-Recipient-Count: 10
X-Local-Recipient-Count: 10
X-Local-Recipient-Defer-Count: 0
X-Local-Recipient-Fail-Count: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.05.2013 19:41, Rik van Riel wrote:

>> I think you should also remove the
>>
>>         if (flags & FAULT_FLAG_WRITE)

Done

>>> Can you test the attached patch?

Nope. Fails with the same symptoms, min_flt skyrockets,
the throttler activates and after 2 seconds all is well
again.

This is on Geode LX, I don't have the Celeron M at the hand now.

Thank
-- 
                                     Stano

