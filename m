Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669Ab3G2QAX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 12:00:23 -0400
Received: from mail-yh0-f41.google.com ([209.85.213.41]:57237 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab3G2QAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 12:00:22 -0400
Date: Mon, 29 Jul 2013 12:00:16 -0400
From: Tejun Heo <tj@kernel.org>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>
Subject: Re: [PATCH] ATA: sata_mv: Remove uneeded CONFIG_HAVE_CLK ifdefs
Message-ID: <20130729160016.GC22605@mtj.dyndns.org>
References: <1375111282-22624-1-git-send-email-ezequiel.garcia@free-electrons.com>
 <1375111282-22624-2-git-send-email-ezequiel.garcia@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375111282-22624-2-git-send-email-ezequiel.garcia@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 12:21:22PM -0300, Ezequiel Garcia wrote:
> If CONFIG_HAVE_CLK is not selected, then all the clk API turn out
> into stubs, so there's no need to have the ifdefs.
> The only side-effect of this patch is the extra tiny kmalloc,
> but that's not enough reason to have such ugly ifdefs all around
> the code.
> 
> Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>

Can you please add a comment in the hpriv definition explaining what
that clk is for and how it's optional and becomes noops when not
needed?

Thanks.

-- 
tejun
