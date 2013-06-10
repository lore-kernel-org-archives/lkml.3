Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab3FKGa4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 02:30:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34716 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab3FKG2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 02:28:45 -0400
Date: Mon, 10 Jun 2013 14:13:50 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH 3.0-stable 1/2] tracing: Fix possible NULL pointer
 dereferences
Message-ID: <20130610211350.GE1602@kroah.com>
References: <51B1A131.9090206@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B1A131.9090206@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 05:00:33PM +0800, Li Zefan wrote:
> commit 6a76f8c0ab19f215af2a3442870eeb5f0e81998d upstream.
> 
> Currently set_ftrace_pid and set_graph_function files use seq_lseek
> for their fops.  However seq_open() is called only for FMODE_READ in
> the fops->open() so that if an user tries to seek one of those file
> when she open it for writing, it sees NULL seq_file and then panic.

You lost the original authorship of this patch, which is a very bad
thing to do.

Ugh, time to edit emails by hand, not my favorite pasttime, someone owes
me a drink...

greg k-h
