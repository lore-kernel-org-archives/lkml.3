Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738Ab3HESjA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 14:39:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:39818 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670Ab3HESi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 14:38:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,820,1367996400"; 
   d="scan'208";a="278017818"
Message-ID: <51FFF140.5020604@linux.intel.com>
Date: Mon, 05 Aug 2013 11:38:56 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        gcc <gcc@gcc.gnu.org>, Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney.cavm@gmail.com>,
        Behan Webster <behanw@converseincode.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: [RFC] gcc feature request: Moving blocks into sections
References: <1375721715.22073.80.camel@gandalf.local.home> <CA+55aFw_o=D-j_SRn=Y4LhHm-tEyuP1Je5ZHVTYxbVyLyDcLEg@mail.gmail.com> <1375725328.22073.101.camel@gandalf.local.home> <CA+55aFwRHpL-3YObZfw6NxxDxMqQbiwp0=NnpotGj2RHDNF3iw@mail.gmail.com> <CA+55aFw=OX3Zz_PJc7NUGwFLAE1RYUsPe9Dn8qHDN0nZeW2R5A@mail.gmail.com> <CA+55aFyzmGzv3C9gy5Xi=pSmAOzpYMNAqrrrZmsvNbt4LdrorQ@mail.gmail.com>
In-Reply-To: <CA+55aFyzmGzv3C9gy5Xi=pSmAOzpYMNAqrrrZmsvNbt4LdrorQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2013 11:34 AM, Linus Torvalds wrote:
> On Mon, Aug 5, 2013 at 11:24 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> Ugh. I can see the attraction of your section thing for that case, I
>> just get the feeling that we should be able to do better somehow.
> 
> Hmm.. Quite frankly, Steven, for your use case I think you actually
> want the C goto *labels* associated with a section. Which sounds like
> it might be a cleaner syntax than making it about the basic block
> anyway.
> 

A label wouldn't have an endpoint, though...

	-hpa


