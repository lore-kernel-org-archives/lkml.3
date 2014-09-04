Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451AbaIDROD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 13:14:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449AbaIDROB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 13:14:01 -0400
Date: Thu, 4 Sep 2014 19:11:13 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@amacapital.net>,
        Denys Vlasenko <dvlasenk@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, X86 ML <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86: reimplement ___preempt_schedule*() using
	THUNK helpers
Message-ID: <20140904171113.GA17355@redhat.com>
References: <20140904134135.GA3309@redhat.com> <20140904134201.GA3312@redhat.com> <CAK1hOcMmOi4vNPrLUtZwtStbs52r15n+h8h+aKCNxTJ1dkOwpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK1hOcMmOi4vNPrLUtZwtStbs52r15n+h8h+aKCNxTJ1dkOwpg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04, Denys Vlasenko wrote:
>
> or thunk_ra should be renamed to THUNK (like it is in thunk_64.S)

Of course! Thanks a lot Denys.

Oleg.

