Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab3KZGfx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 01:35:53 -0500
Received: from us02smtp1.synopsys.com ([198.182.60.75]:45041 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab3KZGfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 01:35:50 -0500
Message-ID: <52944131.2040609@synopsys.com>
Date: Tue, 26 Nov 2013 12:05:29 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.cross-arch,gmane.linux.kernel
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        "Noam Camus" <noamc@ezchip.com>, David Daney <david.daney@cavium.com>,
        James Hogan <james.hogan@imgtec.com>,
        thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>, Richard Kuo <rkuo@codeaurora.org>
Subject: Re: Preventing IPI sending races in arch code
References: <52932BE2.5010201@synopsys.com>	 <20131125110006.GU3866@twins.programming.kicks-ass.net>	 <529334CA.1000401@synopsys.com>	 <20131125122726.GZ10022@twins.programming.kicks-ass.net>	 <C2D7FE5348E1B147BCA15975FBA2307515715C@IN01WEMBXA.internal.synopsys.com>	 <1385409103.9218.15.camel@pasglop> <529427F1.2080409@synopsys.com> <1385442661.9218.51.camel@pasglop>
In-Reply-To: <1385442661.9218.51.camel@pasglop>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 10:41 AM, Benjamin Herrenschmidt wrote:
>> Right, but the issue per-se is not clobbering of msg holder, but from POV of
>> > receiver, seeming coalescing of 2 set_bit writes to msg holder.
> That's fine. There's no expectation that N ipi_send_msg turn into N
> messages received... it turns into at least one.

OK, I was not aware of that relaxation in semantics.

Thx,
-Vineet
