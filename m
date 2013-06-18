Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933349Ab3FRTOT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 15:14:19 -0400
Received: from www.meduna.org ([92.240.244.38]:54993 "EHLO meduna.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933096Ab3FRTOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 15:14:14 -0400
Message-ID: <51C0B177.2000006@meduna.org>
Date: Tue, 18 Jun 2013 21:13:59 +0200
From: Stanislav Meduna <stano@meduna.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Hai Huang <hhuang@redhat.com>
Subject: Re: [PATCH] mm: fix up a spurious page fault whenever it happens
References: <5195ED8B.7060002@meduna.org>  <1369183168.6828.168.camel@gandalf.local.home>  <519CBB30.3060200@redhat.com>  <CA+55aFxMqvDvcVtLW-yD2PuU_CcjPOC30Zk07Kuk6S25WCzbHQ@mail.gmail.com>  <20130522134111.33a695c5@cuia.bos.redhat.com> <519D08B0.8050707@meduna.org> <1369246316.6828.176.camel@gandalf.local.home> <519D0CAB.7020800@meduna.org> <519D0FF8.5080200@redhat.com> <519D118B.6010306@zytor.com> <519D11BF.5000604@redhat.com> <519DCE2A.4010801@meduna.org> <519E095A.4000105@redhat.com> <519F24DD.5060700@meduna.org> <519F65DB.2020305@redhat.com> <51BE2F5C.8070408@meduna.org>
In-Reply-To: <51BE2F5C.8070408@meduna.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Authenticated-User: stano@meduna.org
X-Authenticator: dovecot_plain
X-Spam-Score: -6.9
X-Spam-Score-Int: -68
X-Exim-Version: 4.72 (build at 25-Oct-2012 18:35:58)
X-Date: 2013-06-18 21:14:05
X-Connected-IP: 95.105.165.4:24115
X-Message-Linecount: 34
X-Body-Linecount: 12
X-Message-Size: 1851
X-Body-Size: 371
X-Received-Count: 1
X-Recipient-Count: 10
X-Local-Recipient-Count: 10
X-Local-Recipient-Defer-Count: 0
X-Local-Recipient-Fail-Count: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.06.2013 23:34, Stanislav Meduna wrote:

> Right now a test with the same kernel with preempt none
> is running to see whether the problem also happens with this
> application there (due to the timing sensitivity only a positive
> result has a significance).

No crash in 2 days running with preempt none...

-- 
                                              Stano

