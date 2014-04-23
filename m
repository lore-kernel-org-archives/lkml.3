Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbaDWFlb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 01:41:31 -0400
Received: from ozlabs.org ([103.22.144.67]:50254 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752550AbaDWFlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 01:41:25 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH] Fix: tracing: use 'E' instead of 'X' for unsigned module tain flag
In-Reply-To: <1397574316-518-1-git-send-email-mathieu.desnoyers@efficios.com>
References: <1397574316-518-1-git-send-email-mathieu.desnoyers@efficios.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 23 Apr 2014 13:58:49 +0930
Message-ID: <87eh0ohdoe.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers@efficios.com> writes:
> In the following commit:
>
> commit 57673c2b0baa900dddae3b9eb3d7748ebf550eb3
> Author: Rusty Russell <rusty@rustcorp.com.au>
> Date:   Mon Mar 31 14:39:57 2014 +1030
>
>     Use 'E' instead of 'X' for unsigned module taint flag.
>
> One site has been forgotten in trace events module.h.

Hmm, these are crying out to be unified.

Applied,
Rusty.
