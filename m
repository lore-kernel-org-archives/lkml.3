Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068Ab3KKR6A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 12:58:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755009Ab3KKR5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 12:57:52 -0500
Date: Mon, 11 Nov 2013 18:59:02 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uprobes: Add uprobe_task->dup_work/dup_addr
Message-ID: <20131111175902.GA15457@redhat.com>
References: <20131108190003.GA12755@redhat.com> <20131111071151.GA2559@linux.vnet.ibm.com> <20131111165543.GA12233@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131111165543.GA12233@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11, Oleg Nesterov wrote:
>
> On 11/11, Srikar Dronamraju wrote:
> >
> > Nit:
> > Can we rename dup_addr to mean that it refers to the xol; something like
> > dup_xol_addr or even xol_addr. So that its more clear what address it
> > refers to.
>
> OK. How about dup_xol_work/dup_xol_vaddr ?

I didn't notice you suggested the same naming ;) OK, will rename to
dup_xol_work/addr.

Oleg.

