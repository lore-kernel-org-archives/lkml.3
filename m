Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbaACArb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 19:47:31 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:59228 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752181AbaACAra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 19:47:30 -0500
Date: Thu, 2 Jan 2014 19:47:25 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, pmladek@suse.cz,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/9] smp: Teach __smp_call_function_single() to check
 for offline cpus
Message-ID: <20140102194725.22f1adce@gandalf.local.home>
In-Reply-To: <1387831171-5264-5-git-send-email-jack@suse.cz>
References: <1387831171-5264-1-git-send-email-jack@suse.cz>
	<1387831171-5264-5-git-send-email-jack@suse.cz>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Dec 2013 21:39:25 +0100
Jan Kara <jack@suse.cz> wrote:

> Align __smp_call_function_single() with smp_call_function_single() so
> that it also checks whether requested cpu is still online.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve
