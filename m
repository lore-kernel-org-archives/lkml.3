Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933154AbaDBTdG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 15:33:06 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:56364 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932965AbaDBTdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 15:33:04 -0400
Date: Wed, 2 Apr 2014 15:33:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Kay Sievers <kay@vrfy.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
Message-ID: <20140402153301.53cc7af5@gandalf.local.home>
In-Reply-To: <20140402190851.GD21167@pd.tnic>
References: <20140402144219.4cafbe37@gandalf.local.home>
	<20140402190851.GD21167@pd.tnic>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2014 21:08:51 +0200
Borislav Petkov <bp@alien8.de> wrote:
 
> Well, maybe the minor nit that it leaves two spaces in /proc/cmdline now:
> 
> "root=/dev/sda1  ignore_loglevel log_buf_len=10M earlyprintk=ttyS0,115200 console=ttyS0,115200 console=tty0"
> 
> Also, you need to add
> 
> Suggested-by: PeterZ.

And surprisingly, I forgot to Cc him. How the heck did I miss that :-p

-- Steve

> 
> Other than that:
> 
> Vehemently-and-totally-acked-by: Borislav Petkov <bp@suse.de>
> 
> It is about time this idiotic shit stopped.
> 

