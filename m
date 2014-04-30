Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759415AbaD3PtE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 11:49:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46951 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758924AbaD3PtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 11:49:01 -0400
Date: Wed, 30 Apr 2014 08:49:50 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Vojtech Pavlik <vojtech@suse.cz>, Michael Matz <matz@suse.de>,
        Jiri Kosina <jkosina@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [RFC 09/16] kgr: mark task_safe in some kthreads
Message-ID: <20140430154950.GB898@kroah.com>
References: <1398868249-26169-1-git-send-email-jslaby@suse.cz>
 <1398868249-26169-10-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398868249-26169-10-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 04:30:42PM +0200, Jiri Slaby wrote:
> Some threads do not use kthread_should_stop. Before we enable a
> kthread support in kgr, we must make sure all those mark themselves
> safe explicitly.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Dipankar Sarma <dipankar@in.ibm.com>
> Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> Cc: Tejun Heo <tj@kernel.org>
> ---
>  drivers/base/devtmpfs.c  | 1 +

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
