Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbaCGSPp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 13:15:45 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:65260 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751330AbaCGSPo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 13:15:44 -0500
Date: Fri, 7 Mar 2014 13:15:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr =?UTF-8?B?TWzDoWRlaw==?= <pmladek@suse.cz>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 4/4] x86: Fix order of warning messages when ftrace
 modifies code
Message-ID: <20140307131539.6e224a6c@gandalf.local.home>
In-Reply-To: <20140307084329.GD19132@pathway.suse.cz>
References: <1392650573-3390-1-git-send-email-pmladek@suse.cz>
	<1392650573-3390-5-git-send-email-pmladek@suse.cz>
	<20140306181953.25681923@gandalf.local.home>
	<20140307084329.GD19132@pathway.suse.cz>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Mar 2014 09:43:29 +0100
Petr Mládek <pmladek@suse.cz> wrote:

 
> This patch is nice to have but it is rather cosmetic. I do not mind
> that much about it. Feel free to drop, accept, or just merge into
> any other commit.
> 

OK, I just added it to my 3.16 queue.

-- Steve
