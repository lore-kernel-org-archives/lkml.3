Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933495AbaFINtk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 09:49:40 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:29108 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751702AbaFINth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 09:49:37 -0400
Date: Mon, 9 Jun 2014 09:49:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] kernel/trace/ftrace.c: replace kmalloc/snprintf by
 kasprintf
Message-ID: <20140609094936.0ac57dfb@gandalf.local.home>
In-Reply-To: <1402314441-28851-1-git-send-email-fabf@skynet.be>
References: <1402314441-28851-1-git-send-email-fabf@skynet.be>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  9 Jun 2014 13:47:21 +0200
Fabian Frederick <fabf@skynet.be> wrote:

> @@ -1097,7 +1094,6 @@ static __init void ftrace_profile_debugfs(struct dentry *d_tracer)
>  			return;
>  		}
>  	}
> -

Unneeded change.

-- Steve

>  	entry = debugfs_create_file("function_profile_enabled", 0644,
>  				    d_tracer, NULL, &ftrace_profile_fops);
>  	if (!entry)

