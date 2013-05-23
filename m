Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759394Ab3EWPEJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 11:04:09 -0400
Received: from www.meduna.org ([92.240.244.38]:47342 "EHLO meduna.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759346Ab3EWPEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 11:04:07 -0400
Message-ID: <519E2FD7.90308@meduna.org>
Date: Thu, 23 May 2013 17:03:51 +0200
From: Stanislav Meduna <stano@meduna.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Rik van Riel <riel@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Hai Huang <hhuang@redhat.com>
Subject: Re: [PATCH] mm: fix up a spurious page fault whenever it happens
References: <5195ED8B.7060002@meduna.org> <1369183168.6828.168.camel@gandalf.local.home> <519CBB30.3060200@redhat.com> <CA+55aFxMqvDvcVtLW-yD2PuU_CcjPOC30Zk07Kuk6S25WCzbHQ@mail.gmail.com> <20130522134111.33a695c5@cuia.bos.redhat.com> <519D08B0.8050707@meduna.org> <1369246316.6828.176.camel@gandalf.local.home> <519D0CAB.7020800@meduna.org> <519D0FF8.5080200@redhat.com> <519D118B.6010306@zytor.com> <519D11BF.5000604@redhat.com> <519DCE2A.4010801@meduna.org> <CA+55aFwzedGVew7CCSqZ-Z=2ELt+A4L--mEQGjtALbMSB3LFoQ@mail.gmail.com> <CA+55aFzZdgp0Z3J_6WBAKin-J5k1aLxjaGvLcXxQEuChpD=bXw@mail.gmail.com>
In-Reply-To: <CA+55aFzZdgp0Z3J_6WBAKin-J5k1aLxjaGvLcXxQEuChpD=bXw@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: stano@meduna.org
X-Authenticator: dovecot_plain
X-Spam-Score: -6.9
X-Spam-Score-Int: -68
X-Exim-Version: 4.72 (build at 25-Oct-2012 18:35:58)
X-Date: 2013-05-23 17:03:58
X-Connected-IP: 95.105.165.4:5257
X-Message-Linecount: 31
X-Body-Linecount: 11
X-Message-Size: 1820
X-Body-Size: 297
X-Received-Count: 1
X-Recipient-Count: 10
X-Local-Recipient-Count: 10
X-Local-Recipient-Defer-Count: 0
X-Local-Recipient-Fail-Count: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.05.2013 16:50, Linus Torvalds wrote:

> Another question: I'm assuming this is all 32-bit, is it with PAE
> enabled? That changes some of the TLB flushing, and we had one bug
> related to that, maybe there are others..

32 bit, no PAE.

-- 
                                           Stano

