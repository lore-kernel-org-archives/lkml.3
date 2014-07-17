Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939AbaGQWxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 18:53:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36541 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbaGQWxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 18:53:47 -0400
Date: Thu, 17 Jul 2014 15:53:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/10] proc: fix PAGE_SIZE limit of /proc/$PID/cmdline
Message-Id: <20140717155346.afadf6243dc6c0ebfda95853@linux-foundation.org>
In-Reply-To: <20140716213247.GC21290@p183.telecom.by>
References: <20140716213247.GC21290@p183.telecom.by>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2014 00:32:47 +0300 Alexey Dobriyan <adobriyan@gmail.com> wrote:

> Convert /proc/$PID/cmdline to seq_file interface.
> 
> XXX

Unsure what XXX signifies.

> This one must be buggy.
> 
> seq_file buffer is adjustable, so userspace can execute itself
> with huge command line (which can be arbitrarily long now), then read 1 byte.
> 
> Voila, whole command line now is in kmalloced/vmalloced memory.
> 
> Imposing limit is trivial but equally lame to current PAGE_SIZE limit.

Confused. Why send the patch if you don't like it?

Why not go ahead and impose the PAGE_SIZE limit?
