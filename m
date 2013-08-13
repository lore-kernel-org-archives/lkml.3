Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259Ab3HMPP7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 11:15:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33216 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758185Ab3HMPP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:15:58 -0400
Message-ID: <520A4D5F.6020401@zytor.com>
Date: Tue, 13 Aug 2013 08:14:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, xemul@parallels.com, mpm@selenic.com,
        xiaoguangrong@linux.vnet.ibm.com, mtosatti@redhat.com,
        kosaki.motohiro@gmail.com, sfr@canb.auug.org.au, peterz@infradead.org,
        aneesh.kumar@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 2/2] [PATCH] mm: Save soft-dirty bits on file pages
References: <20130730204154.407090410@gmail.com> <20130730204654.966378702@gmail.com> <20130807132812.60ad4bfe85127794094d385e@linux-foundation.org> <20130808145120.GA1775@moon> <20130812145720.3b722b066fe1bd77291331e5@linux-foundation.org> <CALCETrUXOoKrOAXhvd=GcK3YpBNWr2rk2ArBBgekXDv9yj7sNg@mail.gmail.com> <20130813050213.GA2869@moon>
In-Reply-To: <20130813050213.GA2869@moon>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2013 10:02 PM, Cyrill Gorcunov wrote:
> 
> There is a case when you don't need a mask completely. And because this
> pte conversion is on hot path and time critical I kept generated code
> as it was (even if that lead to slightly less clear source code).
> 

Does it actually matter, generated-code-wise, or is the compiler smart
enough to figure it out?  The reason I'm asking is because it makes the
code much harder to follow.

The other thing is can we please pretty please call it something other
than "frob"?

	-hpa




