Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936296AbaFJDVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 23:21:18 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:59540 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932844AbaFJDVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 23:21:14 -0400
MIME-Version: 1.0
In-Reply-To: <20140609202335.980283946@linutronix.de>
References: <20140609201118.387571774@linutronix.de>
	<20140609202335.980283946@linutronix.de>
Date: Mon, 9 Jun 2014 20:21:13 -0700
X-Google-Sender-Auth: DStdn_fT8sSZGe9BFQCYgkdyikU
Message-ID: <CAGQ1y=6b6hMVD2ECmJ1V0EB=Rywz10Y29pnfXOFFLN2YuO6BKA@mail.gmail.com>
Subject: Re: [patch V3 1/7] rtmutex: Deobfuscate chain walk
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
> There is no point to keep the task ref across the check for lock
> owner. Drop the ref before that, so the protection context is clear.
>
> Found while documenting the chain walk.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Reviewed-by: Jason Low <jason.low2@hp.com>
