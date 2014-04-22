Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbaDVHjg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 03:39:36 -0400
Received: from ozlabs.org ([103.22.144.67]:41947 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384AbaDVHjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 03:39:11 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Takao Indoh <indou.takao@jp.fujitsu.com>
Cc: rostedt@goodmis.org, masami.hiramatsu.pt@hitachi.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] module: Introduce MODULE_STATE_COMING_FINAL to avoid ftrace warning
In-Reply-To: <534B4CB5.9010401@jp.fujitsu.com>
References: <1396425266-3128-1-git-send-email-indou.takao@jp.fujitsu.com> <534B4CB5.9010401@jp.fujitsu.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 22 Apr 2014 16:20:05 +0930
Message-ID: <874n1lj1sy.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takao Indoh <indou.takao@jp.fujitsu.com> writes:
> ping, any comments?

Sorry, was away on paternity leave.

I prefer to mark NX before changing the module to MODULE_STATE_COMING,
but perhaps that will break everyone else?

See my reply to the other thread.

Thanks,
Rusty.
