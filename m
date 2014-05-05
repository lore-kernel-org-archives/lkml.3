Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647AbaEEU7K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 16:59:10 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:52278 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755293AbaEEU7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 16:59:07 -0400
X-Sasl-enc: Mzv5powoM0kaIZiqApsiZcomXxrTbdtok8YAq/bVsQtt 1399323546
Date: Mon, 5 May 2014 14:02:11 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Herring <robh@kernel.org>
Subject: Re: linux-next: manual merge of the tty tree with Linus' tree
Message-ID: <20140505210211.GA27503@kroah.com>
References: <20140505154103.941b62e29706efa62b826354@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140505154103.941b62e29706efa62b826354@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2014 at 03:41:03PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the tty tree got a conflict in
> arch/arm64/kernel/early_printk.c between commit f774b7d10e21 ("arm64:
> fixmap: fix missing sub-page offset for earlyprintk") from the  tree and
> commit 8ef0ed95ee04 ("arm64: remove arch specific earlyprintk") from the
> tty tree.
> 
> I fixed it up (I removed the file) and can carry the fix as necessary (no
> action is required).

That sounds fine to me, thanks.

greg k-h
