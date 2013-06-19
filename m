Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934038Ab3FSI0r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 04:26:47 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43487 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933755Ab3FSI0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 04:26:46 -0400
Date: Wed, 19 Jun 2013 09:26:19 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Jonathan Austin <jonathan.austin@arm.com>
Subject: Re: linux-next: manual merge of the arm-mpidr tree with the arm
	tree
Message-ID: <20130619082619.GA31513@flint.arm.linux.org.uk>
References: <20130619104409.358078cdc4957fa6832f3413@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130619104409.358078cdc4957fa6832f3413@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 10:44:09AM +1000, Stephen Rothwell wrote:
> Hi Lorenzo,
> 
> Today's linux-next merge of the arm-mpidr tree got a conflict in
> arch/arm/kernel/suspend.c between commit aa1aadc3305c ("ARM: suspend: fix
> CPU suspend code for !CONFIG_MMU configurations") from the arm tree and
> commit 3fed6a1e3bf0 ("ARM: kernel: implement stack pointer save array
> through MPIDR hashing") from the arm-mpidr tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
> 
> P.S. that arm tree commit above has no Signed-off-by from its
> committer :-(

Oh bloody hell.  Now what do I do about that.  The branch is a declared
stable branch, and the commit came in from someone elses tree.  So it's
immutable...

Is there any script around which checks that kind of stuff?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
