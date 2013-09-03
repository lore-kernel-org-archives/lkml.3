Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932746Ab3ICJEj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 05:04:39 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51997 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932372Ab3ICJEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 05:04:38 -0400
Date: Tue, 3 Sep 2013 10:04:14 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: linux-next: build failure after merge of the final tree (arm
	tree related)
Message-ID: <20130903090414.GA25658@flint.arm.linux.org.uk>
References: <20130903181824.796e74465274b23387d3e715@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130903181824.796e74465274b23387d3e715@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 03, 2013 at 06:18:24PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (arm defconfig)
> failed like this:
> 
> arch/arm/kernel/built-in.o: In function `setup_arch':
> io.c:(.init.text+0x594): undefined reference to `erratum_a15_798181_init'
> 
> Presumably caused by commit 34905a33184a ("ARM: 7804/2: Add check for
> Cortex-A15 errata 798181 ECO").  This build does not have CONFIG_SMP set.
> 
> I have reverted that commit for today.

Yep, and I think I'm going to do the same, rather than try and fix it.

-- 
Russell King
