Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932874AbaJVUfN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 16:35:13 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:42980 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932812AbaJVUfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 16:35:09 -0400
Date: Wed, 22 Oct 2014 16:35:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Michal Marek <mmarek@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Masahiro Yamada <yamada.m@jp.panasonic.com>,
        Peter Foley <pefoley2@pefoley.com>, linux-kbuild@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kbuild: Fix output of make kernelrelease
Message-ID: <20141022163507.6e2162d1@gandalf.local.home>
In-Reply-To: <20141022194408.GA20989@pobox.suse.cz>
References: <20141022101944.70d637cc@gandalf.local.home>
	<20141022194408.GA20989@pobox.suse.cz>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2014 21:44:08 +0200
Michal Marek <mmarek@suse.cz> wrote:

> Dne 22.10.2014 v 16:19 Steven Rostedt napsal(a):
> > 
> > Commit 7ff525712acf "kbuild: fake the "Entering directory ..." message
> > more simply" changed the output of "make kernelrelease" such that the
> > kernel release version was not the last line printed. This broke various
> > tools that would find the kernel release with "make kernelrelease | tail -1".
> 
> The cleaner and recommended (see recent make help) way is to use make -s:
> 
> $ make O=build -s kernelrelease
> 3.18.0-rc1+

Hmm, I see the help index was recently updated to include that.

Does this work with older kernels too? That's very important.

-- Steve
