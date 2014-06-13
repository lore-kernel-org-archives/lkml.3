Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbaFMQfj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 12:35:39 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:48409 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751300AbaFMQfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 12:35:38 -0400
Date: Fri, 13 Jun 2014 12:35:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [patch V4 05/10] rtmutex: Clarify the boost/deboost part
Message-ID: <20140613123536.44b95349@gandalf.local.home>
In-Reply-To: <20140611183853.297793547@linutronix.de>
References: <20140611182944.108526809@linutronix.de>
	<20140611183853.297793547@linutronix.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2014 18:44:06 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:

> Add a separate local variable for the boost/deboost logic to make the
> code more readable. Add comments where appropriate.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Already-reviewed-by: Steven Rostedt <rostedt@goodmis.org>

(I added my RB tag to the last version, and noticed this didn't change)

-- Steve
