Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbaKEUcK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 15:32:10 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:47332 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751602AbaKEUcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 15:32:07 -0500
Date: Wed, 5 Nov 2014 15:32:05 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 09/12 v3] seq_buf: Move the seq_buf code to lib/
Message-ID: <20141105153205.408146c6@gandalf.local.home>
In-Reply-To: <20141105165726.GK4570@pathway.suse.cz>
References: <20141104155237.228431433@goodmis.org>
	<20141104160222.809349817@goodmis.org>
	<20141105165726.GK4570@pathway.suse.cz>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Nov 2014 17:57:26 +0100
Petr Mladek <pmladek@suse.cz> wrote:


> This patch might needed an update when there are changes in the
> previous patches. But it is a simple file move that makes
> perfect sense, so:

I love git rebase. It knows that this change was a simple file move and
even if you change the file that is moving, it wont have any conflicts
during the rebase.

> 
> Reviewed-by: Petr Mladek <pmladek@suse.cz>

Thanks,

-- Steve

