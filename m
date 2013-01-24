Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab3AXOTh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 09:19:37 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:40584 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934Ab3AXOTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 09:19:35 -0500
Date: Thu, 24 Jan 2013 15:19:30 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Fabio Estevam <festevam@gmail.com>
Cc: mingo@redhat.com, peterz@infradead.org, pjt@google.com,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH v2] sched: Fix print format for u64
Message-ID: <20130124141930.GA14881@gmail.com>
References: <1356434680-10045-1-git-send-email-festevam@gmail.com>
 <CAOMZO5AzJUvrc5LcNyqPbEz0g4U5KZAXrNK8oJUiht=fdyuc5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5AzJUvrc5LcNyqPbEz0g4U5KZAXrNK8oJUiht=fdyuc5g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Fabio Estevam <festevam@gmail.com> wrote:

> Hi Ingo,
> 
> On Tue, Dec 25, 2012 at 9:24 AM, Fabio Estevam <festevam@gmail.com> wrote:
> > From: Fabio Estevam <fabio.estevam@freescale.com>
> >
> > commit c566e8e9 (sched: Aggregate total task_group load) introduced the
> > following build warning:
> >
> > kernel/sched/debug.c:225:2: warning: format '%ld' expects argument of type 'long int', but argument 4 has type 'u64' [-Wformat]
> > kernel/sched/debug.c:225:2: warning: format '%ld' expects argument of type 'long int', but argument 3 has type 'u64' [-Wformat]
> >
> > Use %llu format to print a u64 value as per Documentation/printk-formats.txt.
> >
> > Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Does this one look good?

I suppose - is this patch warning-free both on 64-bit and 32-bit 
systems?

Thanks,

	Ingo
