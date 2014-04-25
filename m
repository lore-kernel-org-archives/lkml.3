Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670AbaDYIWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 04:22:23 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:56046 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbaDYIVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 04:21:01 -0400
Date: Fri, 25 Apr 2014 10:20:56 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, fche@redhat.com,
        mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH -tip v9 25/26] kprobes: Introduce kprobe cache to reduce
 cache misshits
Message-ID: <20140425082056.GB24829@gmail.com>
References: <20140417081636.26341.87858.stgit@ltc230.yrl.intra.hitachi.co.jp>
 <20140417081931.26341.47154.stgit@ltc230.yrl.intra.hitachi.co.jp>
 <20140424090134.GC7768@gmail.com>
 <5358F7A3.1000108@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5358F7A3.1000108@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> > So I don't think this should be a Kconfig entry, just enable it 
> > unconditionally. That will further simplify the code.
> 
> Hmm, it consumes some amount of memory (36KB/core) just for the case 
> of several thousand of kprobes. On enterprise servers and desktop 
> it's OK, no problem. But I think, some embedded systems with small 
> resources will not want that. [...]

They'll just disable kprobes in general.

Really, at this point complexity is our main concern.

Thanks,

	Ingo
