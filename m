Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936312AbaFJDWn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 23:22:43 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:52513 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932844AbaFJDWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 23:22:42 -0400
MIME-Version: 1.0
In-Reply-To: <20140609202336.068962483@linutronix.de>
References: <20140609201118.387571774@linutronix.de>
	<20140609202336.068962483@linutronix.de>
Date: Mon, 9 Jun 2014 20:22:41 -0700
X-Google-Sender-Auth: Cr0fykivROhDCrUCdN_yTe3zyo8
Message-ID: <CAGQ1y=40b0jWM57_ri3UrupD=GpJQfbpCW2UOSNOfVKJ7N_g6Q@mail.gmail.com>
Subject: Re: [patch V3 2/7] rtmutex: Clarify the boost/deboost part
From: Jason Low <jason.low2@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jason Low <jason.low2@hp.com>,
        Brad Mouring <bmouring@ni.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 9, 2014 at 1:28 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Add a separate local variable for the boost/deboost logic to make the
> code more readable. Add comments where appropriate.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Reviewed-by: Jason Low <jason.low2@hp.com>
