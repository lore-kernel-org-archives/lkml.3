Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450AbaAFLct (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 06:32:49 -0500
Received: from www.linutronix.de ([62.245.132.108]:51446 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933AbaAFLcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 06:32:48 -0500
Date: Mon, 6 Jan 2014 12:32:30 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ben Hutchings <ben@decadent.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>, 723180@bugs.debian.org,
        Brian Silverman <bsilver16384@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH] Revert "x86: Disable IST stacks for debug/int 3/stack
 fault for PREEMPT_RT"
Message-ID: <20140106113230.GA25261@linutronix.de>
References: <20130917061329.4872.51468.reportbug@dell-inspiron-linux.dlinkrouter>
 <1379427451.23881.48.camel@deadeye.wl.decadent.org.uk>
 <CAP01z6LVxoA6kDJeL8NuO2aA22BjMvXSk9ZY7z9cOK1=k56vpg@mail.gmail.com>
 <1379905562.3913.8.camel@deadeye.wl.decadent.org.uk>
 <CAP01z6+j6moUio9pc3G3iz+ebJCdKEvngddxnxazRP+NXwLkyg@mail.gmail.com>
 <1380115449.4430.21.camel@deadeye.wl.decadent.org.uk>
 <52AE0419.3050103@linutronix.de>
 <20140103135548.GA6327@linutronix.de>
 <20140104181807.GS20765@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140104181807.GS20765@two.firstfloor.org>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen | 2014-01-04 19:18:07 [+0100]:

>On Fri, Jan 03, 2014 at 02:55:48PM +0100, Sebastian Andrzej Siewior wrote:
>> where do I start. Let me explain what is going on here. The code
>> sequence
>
>Yes the IST stacks are needed for correctness, even in more cases than
>the example below. You cannot just disable them, just because you don't
>like them.

Andi, you were the Author of that patch.
I plan to migrate from the IST stack to the kernel stack so I can enable
preemption. This is he case on 32bit. You mention more cases than this.
Could you please give me some examples so I can consider them?

>-Andi

Sebastian
