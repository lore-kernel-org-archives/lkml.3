Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255AbaDXI66 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:58:58 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:47538 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbaDXI6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:58:53 -0400
Date: Thu, 24 Apr 2014 10:58:47 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        "David S. Miller" <davem@davemloft.net>, fche@redhat.com,
        mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH -tip v9 22/26] kprobes/x86: Use kprobe_blacklist for
 .kprobes.text and .entry.text
Message-ID: <20140424085847.GB7768@gmail.com>
References: <20140417081636.26341.87858.stgit@ltc230.yrl.intra.hitachi.co.jp>
 <20140417081910.26341.58385.stgit@ltc230.yrl.intra.hitachi.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140417081910.26341.58385.stgit@ltc230.yrl.intra.hitachi.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> Use kprobe_blackpoint for blacklisting .entry.text and .kprobees.text
> instead of arch_within_kprobe_blacklist. This also makes them visible
> via (debugfs)/kprobes/blacklist.

This description references kprobe_blackpoint, which name I don't 
think exists anymore.

Thanks,

	Ingo
