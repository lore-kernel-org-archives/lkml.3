Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbaFEBU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 21:20:58 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:41491 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753360AbaFEBU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 21:20:56 -0400
Date: Wed, 4 Jun 2014 21:20:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the ftrace tree
Message-ID: <20140604212053.4cc3b533@gandalf.local.home>
In-Reply-To: <20140604211202.0eb5d147@gandalf.local.home>
References: <20140604160921.4f4e69c4@canb.auug.org.au>
	<20140604122612.366e2874@gandalf.local.home>
	<20140605002012.GA10446@localhost>
	<20140604210016.4766adba@gandalf.local.home>
	<20140605010353.GA13193@localhost>
	<20140604211202.0eb5d147@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2014 21:12:02 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:


> I may add a bad commit to one of my branches and see if I get a
> response from you just to test it out. I really hope we can fix this
> because I've gotten someone dependent on your reports. :-/

I did just this. I created a branch called test-wu-bot and added a
commit that removed a semicolon. I pushed it up to kernel.org. Now I'll
just sit back to see if it reports a build failure.

Thanks,

-- Steve
