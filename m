Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618AbaKRA46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 19:56:58 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:41756 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753585AbaKRA45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 19:56:57 -0500
Date: Mon, 17 Nov 2014 19:56:51 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>
Subject: Re: [PATCH 20/26 v5] seq_buf: Add seq_buf_can_fit() helper function
Message-ID: <20141117195651.27c79369@gandalf.local.home>
In-Reply-To: <1416270932.29010.6.camel@perches.com>
References: <20141115045847.712848224@goodmis.org>
	<20141115050604.073390701@goodmis.org>
	<20141117123642.1de9252e@gandalf.local.home>
	<1416269253.29010.4.camel@perches.com>
	<20141117192733.0ab1ba2e@gandalf.local.home>
	<1416270932.29010.6.camel@perches.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2014 16:35:32 -0800
Joe Perches <joe@perches.com> wrote:

 
> What "logic" does it place in one place and
> how does it matter?

Look at the next patch.

> 
> I don't see it making mistakes more or less
> likely, I just see it being used to avoid
> setting the overflow state which seems like
> more of an error than anything else.
> 
> Why avoid setting overflow at all?
> 

It has nothing to do with overflow. Where did you get that from?

It has to do with updating the seq->len value or not.

-- Steve

