Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbaAVBSL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 20:18:11 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:47472 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752677AbaAVBSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 20:18:09 -0500
Date: Tue, 21 Jan 2014 20:18:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Petr Mladek <pmladek@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH v6 1/8] x86: allow to handle errors in text_poke
 function family
Message-ID: <20140121201806.2923b9c6@gandalf.local.home>
In-Reply-To: <52DF1633.1070404@hitachi.com>
References: <1386690140-19941-1-git-send-email-pmladek@suse.cz>
	<1386690140-19941-2-git-send-email-pmladek@suse.cz>
	<20140114182029.27fa13f9@gandalf.local.home>
	<1390309237.14199.16.camel@pathway.suse.cz>
	<20140121090229.5936c2ba@gandalf.local.home>
	<52DF1633.1070404@hitachi.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jan 2014 09:52:03 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> What about using text_poke() for BUG_ON and __text_poke()
> for returning an error ? This may not change caller sites.
> 


Sounds fine with me.

-- Steve
