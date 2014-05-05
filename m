Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933125AbaEEOwo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 10:52:44 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:10349 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932448AbaEEOwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 10:52:43 -0400
Date: Mon, 5 May 2014 10:52:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Dan Streetman <ddstreet@ieee.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] plist: replace pr_debug with printk in plist_test()
Message-ID: <20140505105224.3024e4ca@gandalf.local.home>
In-Reply-To: <1399300985-11137-1-git-send-email-ddstreet@ieee.org>
References: <CALZtONB-wT16fPX7GjBVFO_5Bof3=zxviG22p6_9ymbnzA9QAA@mail.gmail.com>
	<1399300985-11137-1-git-send-email-ddstreet@ieee.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  5 May 2014 10:43:05 -0400
Dan Streetman <ddstreet@ieee.org> wrote:

> Replace pr_debug() in lib/plist.c test function plist_test() with
> printk(KERN_DEBUG ...).
> 
> Without DEBUG defined, pr_debug() is complied out, but the entire
> plist_test() function is already inside CONFIG_DEBUG_PI_LIST, so
> printk should just be used directly.
> 
> Signed-off-by: Dan Streetman <ddstreet@ieee.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

