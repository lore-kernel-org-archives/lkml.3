Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760124Ab3CZUKy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 16:10:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51147 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab3CZUKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 16:10:53 -0400
Date: Tue, 26 Mar 2013 13:10:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Jens Axboe <axboe@kernel.dk>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the final tree (akpm
 and block tree related)
Message-Id: <20130326131051.a47fe83fdbdab4b824394f18@linux-foundation.org>
In-Reply-To: <20130326195523.GB24935@google.com>
References: <20130326170554.f9f113fa24a1e5ec6d5d1ee6@canb.auug.org.au>
	<20130326195523.GB24935@google.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Mar 2013 12:55:23 -0700 Kent Overstreet <koverstreet@google.com> wrote:

> On Tue, Mar 26, 2013 at 05:05:54PM +1100, Stephen Rothwell wrote:
> > Hi all,
> > 
> > After merging the final tree, today's linux-next build
> > produced this warning:
> > 
> > fs/bio.c: In function 'submit_bio_wait':
> > fs/bio.c:786:17: warning: assignment from incompatible pointer type [enabled by default]
> > 
> > This is due to an interaction between commit 9e882242c ("block: Add
> > submit_bio_wait(), remove from md") from the block tree and commit
> > "block: prep work for batch completion" from the akpm tree.
> 
> In hindsight maybe it would've been better if the batch completion stuff
> had gone in via Jens' tree, though I'm sure there would've still been
> some conflicts.
> 
> What's the procedure for me to fix these? I can send you a fixup patch
> but if you've pushed this version of linux-next somewhere public I'm not
> sure where to look.

Stephen and I quietly fix up this sort of thing.
