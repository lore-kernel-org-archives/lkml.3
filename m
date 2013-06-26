Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab3FZILt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 04:11:49 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46513 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab3FZIKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 04:10:38 -0400
Date: Wed, 26 Jun 2013 09:09:36 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the arm-mpidr tree with the arm
	tree
Message-ID: <20130626080936.GD7193@flint.arm.linux.org.uk>
References: <20130626110411.d1fe3913769385fa056010be@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130626110411.d1fe3913769385fa056010be@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 11:04:11AM +1000, Stephen Rothwell wrote:
> Hi Lorenzo,
> 
> Today's linux-next merge of the arm-mpidr tree got a conflict in
> arch/arm/kernel/suspend.c between commit 7604537bbb57 ("ARM: kernel:
> implement stack pointer save array through MPIDR hashing") from the arm
> tree and commit 3fed6a1e3bf0 ("ARM: kernel: implement stack pointer save
> array through MPIDR hashing") from the arm-mpidr tree.
> 
> The former is just a rebase of the latter, so I used it.  It then turns
> out that the arm-mpidr contains nothing that is not already included in
> the arm tree, so is it needed any more i.e. is there further work coming?

The reason for this is that the changes were submitted to me as patches
as two of the changes are for -rc, the other one is a development change,
but in Lorenzo's git tree, they're all part of a single branch, and so
can't be separately pushed upstream.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
