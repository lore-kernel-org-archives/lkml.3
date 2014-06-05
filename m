Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbaFECgf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 22:36:35 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:60237 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751854AbaFECge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 22:36:34 -0400
Date: Wed, 4 Jun 2014 22:36:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the ftrace tree
Message-ID: <20140604223624.6d338b5b@gandalf.local.home>
In-Reply-To: <20140605021457.GA19061@localhost>
References: <20140604160921.4f4e69c4@canb.auug.org.au>
	<20140604122612.366e2874@gandalf.local.home>
	<20140605002012.GA10446@localhost>
	<20140604210016.4766adba@gandalf.local.home>
	<20140605010353.GA13193@localhost>
	<20140604211202.0eb5d147@gandalf.local.home>
	<20140605013300.GA13341@localhost>
	<20140604213932.5a48112d@gandalf.local.home>
	<20140605021457.GA19061@localhost>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jun 2014 10:14:57 +0800
Fengguang Wu <fengguang.wu@intel.com> wrote:

> > I wonder if the "(Red Hat)" part is causing an issue. Can you send
> > directly to my email "rostedt@goodmis.org" and strip the name part?
> 
> OK. I've committed the change. Let's see how well it will work.

OK, I never received an error message for my buggy commit I posted
before you did this change. I fixed the buggy commit and added another
bug. I'll now wait again to see if I get notified.

-- Steve
