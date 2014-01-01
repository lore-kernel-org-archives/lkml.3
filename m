Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbaAAT5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 14:57:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58215 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754556AbaAAT5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 14:57:43 -0500
Message-ID: <52C47170.9050702@zytor.com>
Date: Wed, 01 Jan 2014 11:50:08 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
CC: Kees Cook <keescook@chromium.org>, David Rientjes <rientjes@google.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        James Hogan <james.hogan@imgtec.com>, Michal Marek <mmarek@suse.cz>,
        Paul Mundt <lethal@linux-sh.org>, Shawn Guo <shawn.guo@linaro.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [patch core/stackprotector] stackprotector: Fix build when compiler
 lacks support
References: <1387481759-14535-3-git-send-email-keescook@chromium.org>	<tip-8779657d29c0ebcc0c94ede4df2f497baf1b563f@git.kernel.org>	<alpine.DEB.2.02.1312301331520.10482@chino.kir.corp.google.com>	<CAGXu5jJxkD7rS0gFAS3mAhwxP05UMW8KNW00C_e2v=Keqj7k3Q@mail.gmail.com>	<CA+55aFy65HwuqjsZhhTDBy1GYyxig8De=3XZxn8ixnGN7xWMFQ@mail.gmail.com>	<20140101114244.GB3372@free.fr> <CA+55aFzS2bTXSDabNhsZXhpVWP9toqtubB3jrNVWF-FaQrmz-w@mail.gmail.com>
In-Reply-To: <CA+55aFzS2bTXSDabNhsZXhpVWP9toqtubB3jrNVWF-FaQrmz-w@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/01/2014 11:33 AM, Linus Torvalds wrote:
> 
> Ack. Looks good to me. I've wanted this for a long time for other
> reasons, we should finally just do it.
> 

Yes, we keep avoiding doing this by layering hack upon hack, but
really... it needs to be done.

The chief objection I've heard is that it makes "make oldconfig"
necessary after a compiler change, but that seems entirely reasonable.

	-hpa


