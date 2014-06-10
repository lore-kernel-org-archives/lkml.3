Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936143AbaFJAf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 20:35:28 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:51541 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932317AbaFJAfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 20:35:24 -0400
Date: Mon, 9 Jun 2014 20:35:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jason Low <jason.low2@hp.com>,
        Brad Mouring <bmouring@ni.com>
Subject: Re: [patch V3 0/7] rtmutex: Code clarification and optimization
Message-ID: <20140609203522.1a339d7c@gandalf.local.home>
In-Reply-To: <20140609202713.32e649ea@gandalf.local.home>
References: <20140609201118.387571774@linutronix.de>
	<20140609202713.32e649ea@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2014 20:27:13 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:


> So what branch do these apply to? I tried latest Linus master and it
> didn't apply.

OK, they seem to be on tip/locking/urgent. Not yet in mainline.

-- Steve
