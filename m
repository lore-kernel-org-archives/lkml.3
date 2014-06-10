Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964907AbaFJAhS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 20:37:18 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:22836 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934307AbaFJAhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 20:37:14 -0400
Date: Mon, 9 Jun 2014 20:37:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Jason Low <jason.low2@hp.com>, Brad Mouring <bmouring@ni.com>
Subject: Re: [patch V3 2/7] rtmutex: Clarify the boost/deboost part
Message-ID: <20140609203712.1edc58e8@gandalf.local.home>
In-Reply-To: <20140609202336.068962483@linutronix.de>
References: <20140609201118.387571774@linutronix.de>
	<20140609202336.068962483@linutronix.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Jun 2014 20:28:07 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:

> Add a separate local variable for the boost/deboost logic to make the
> code more readable. Add comments where appropriate.
> 

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

