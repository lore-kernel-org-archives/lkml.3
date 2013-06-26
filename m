Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896Ab3FZNN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 09:13:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50543 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab3FZNN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 09:13:27 -0400
Date: Wed, 26 Jun 2013 06:13:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Neuling <mikey@neuling.org>,
        linuxppc-dev@lists.ozlabs.org, Oleg Nesterov <oleg@redhat.com>
Subject: Re: linux-next: manual merge of the akpm tree with the powerpc tree
Message-Id: <20130626061300.6b2da9e3.akpm@linux-foundation.org>
In-Reply-To: <1372234231.18612.6.camel@pasglop>
References: <20130626165642.8740ecb6d5d5882b06f173c8@canb.auug.org.au>
	<1372234231.18612.6.camel@pasglop>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Jun 2013 18:10:31 +1000 Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Wed, 2013-06-26 at 16:56 +1000, Stephen Rothwell wrote:
> > Today's linux-next merge of the akpm tree got a conflict in
> > arch/powerpc/kernel/ptrace.c between commit b0b0aa9c7faf
> > ("powerpc/hw_brk: Fix setting of length for exact mode breakpoints") from
> > the powerpc tree and commit "ptrace/powerpc: revert "hw_breakpoints: Fix
> > racy access to ptrace breakpoints"" from the akpm tree.
> > 
> > I fixed it up (see below) and can carry the fix as necessary (no action
> > is required).
> 
> Where does the latter come from ? Why didn't it go through the powerpc tree ?

um, the most rudimentary search will take you to Oleg's patch series. 
You were cc'ed on the whole thing two or three times.

