Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160AbaGUNut (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 09:50:49 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:9860 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751799AbaGUNus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 09:50:48 -0400
Date: Mon, 21 Jul 2014 09:50:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftrace: kill global_start_up
Message-ID: <20140721095046.4343746d@gandalf.local.home>
In-Reply-To: <20140721094706.60eb3877@gandalf.local.home>
References: <20140720151814.GA32439@redhat.com>
	<20140721094706.60eb3877@gandalf.local.home>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2014 09:47:06 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Sun, 20 Jul 2014 17:18:14 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
> 
> > global_start_up is read-only and always zero. It seems that 4104d326
> > "ftrace: Remove global function list and call function directly" simply
> > forgot to remove this no longer used variable.
> > 
> 
> Sure, just after I got done testing my entire 3.17 queue and posted it
> for linux-next, you decide to send me yet another fix! ;-)
> 
> Thanks, applied.
> 
> I'll wait and see what other fixes you send me before I run my 10 hour
> tests.
> 

Nevermind, seems that Namhyung Kim beat you to it (and it's already in
my for-next branch).

http://lkml.kernel.org/r/1402584972-17824-1-git-send-email-namhyung@kernel.org

-- Steve
