Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab3BUQtp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 11:49:45 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:35956 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab3BUQtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 11:49:43 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1302211743350.22263@ionos>
References: <1361373336-11337-1-git-send-email-fweisbec@gmail.com>
	<alpine.LFD.2.02.1302202155320.22263@ionos>
	<CAFTL4hx_uXfY=bH9nnEsN6AJFTcwqdAWTxcR0jc=hL1FBrwk0w@mail.gmail.com>
	<alpine.LFD.2.02.1302210013070.22263@ionos>
	<CAFTL4hz7xmi910Gv0uXAM2AReC4iZzAo3gfMtPk1Yh6wRi1OOg@mail.gmail.com>
	<alpine.LFD.2.02.1302211743350.22263@ionos>
Date: Thu, 21 Feb 2013 17:49:42 +0100
Message-ID: <CAFTL4hwhesW96zTu7+YtdUshQm_HMXFsNBwS2BWo5UcTXtgKHw@mail.gmail.com>
Subject: Re: [PATCH] nohz: Make tick_nohz_irq_exit() irq safe
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/21 Thomas Gleixner <tglx@linutronix.de>:
> On Thu, 21 Feb 2013, Frederic Weisbecker wrote:
> Second thoughts. I probably go for your minimal fix for stable and
> then push my version on top of it to Linus only.

Thanks, I feel more comfortable with that. Then I'll try to iterate
over archs to finally remove that damn macro.
