Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759605Ab3HNPoe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 11:44:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46348 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896Ab3HNPoc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 11:44:32 -0400
Message-ID: <520BA590.2030808@zytor.com>
Date: Wed, 14 Aug 2013 08:43:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mike Galbraith <bitbucket@online.de>
CC: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [RFC][PATCH 0/5] preempt_count rework
References: <20130814131539.790947874@chello.nl>  <520B8A81.1080405@zytor.com> <1376494751.7355.28.camel@marge.simpson.net>
In-Reply-To: <1376494751.7355.28.camel@marge.simpson.net>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2013 08:39 AM, Mike Galbraith wrote:
> 
> ..so could the rq = cpu_rq(cpu) sequence be improved cycle expenditure
> wise by squirreling rq pointer away in a percpu this_rq, and replacing
> cpu_rq(cpu) above with a __this_cpu_read(this_rq) version of this_rq()?
> 

Yes.

	-hpa


