Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297AbaCMDWW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 23:22:22 -0400
Received: from ozlabs.org ([203.10.76.45]:50208 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753139AbaCMDWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 23:22:19 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Howells <dhowells@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] Fix: module signature vs tracepoints: add new TAINT_UNSIGNED_MODULE
In-Reply-To: <20140226154012.7985f91c@gandalf.local.home>
References: <1392355106-26104-1-git-send-email-mathieu.desnoyers@efficios.com> <20140226154012.7985f91c@gandalf.local.home>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Thu, 13 Mar 2014 11:30:47 +1030
Message-ID: <87siqmvrnk.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:
> Mathieu, you should have added a v2 to the subject ie: [PATCH V2]
>
> Rusty,
>
> If you want to take this, please add my
> Acked-by: Steven Rostedt <rostedt@goodmis.org>

Thanks, I updated my copy and have pushed this into modules-next.

Cheers,
Rusty.
