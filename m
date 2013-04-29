Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030Ab3D2DlN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 23:41:13 -0400
Received: from gate.crashing.org ([63.228.1.57]:59997 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756821Ab3D2DlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 23:41:12 -0400
Message-ID: <1367206844.7288.0.camel@pasglop>
Subject: Re: linux-next: manual merge of the vfs tree with the powerpc tree
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Vasant Hegde <hegdevasant@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Date: Mon, 29 Apr 2013 13:40:44 +1000
In-Reply-To: <20130429113540.55b2593d303bc2a9142919fc@canb.auug.org.au>
References: <20130429113540.55b2593d303bc2a9142919fc@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-29 at 11:35 +1000, Stephen Rothwell wrote:
> Today's linux-next merge of the vfs tree got a conflict in
> arch/powerpc/kernel/rtas_flash.c between commit ad18a364f186
> ("powerpc/rtas_flash: Free kmem upon module exit"),  from the powerpc
> tree and commit 5c0333c00ff6 ("ppc: Clean up rtas_flash driver
> somewhat")
> from the vfs tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no
> action
> is required).

Please don't merge Dave's rework until it's been acked & fully tested by
us. AFAIK, there are outstanding comments from my guys who
reviewed/tested the first pass.

Cheers,
Ben.


