Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbaDCQeU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 12:34:20 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:31884 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752829AbaDCQeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 12:34:14 -0400
Date: Thu, 3 Apr 2014 12:34:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathias Krause <minipli@googlemail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, PaX Team <pageexec@freemail.hu>
Subject: Re: [PATCH] ftrace: Statically initialize pm notifier block
Message-ID: <20140403123411.04fc8b94@gandalf.local.home>
In-Reply-To: <1396186310-3156-1-git-send-email-minipli@googlemail.com>
References: <1396186310-3156-1-git-send-email-minipli@googlemail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Mar 2014 15:31:50 +0200
Mathias Krause <minipli@googlemail.com> wrote:

> Instead of initializing the pm notifier block in register_ftrace_graph(),
> initialize it statically. This safes us some code.
> 
> Found in the PaX patch, written by the PaX Team.
> 
> Cc: PaX Team <pageexec@freemail.hu>
> Signed-off-by: Mathias Krause <minipli@googlemail.com>
> ---

I'll queue this up for 3.16.

Thanks,

-- Steve
