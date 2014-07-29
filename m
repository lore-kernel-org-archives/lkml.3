Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317AbaG2Pgk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 11:36:40 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:36167 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752036AbaG2Pgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 11:36:38 -0400
X-Sasl-enc: 1a+59xottsbyZwzNbB+F8vBos0iQkfK/IUShUCc0WdGz 1406648194
Date: Tue, 29 Jul 2014 08:36:07 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>, Vinod Koul <vinod.koul@intel.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Siva Yerramreddy <yshivakrishna@gmail.com>
Subject: Re: linux-next: manual merge of the char-misc tree with the
 slave-dma tree
Message-ID: <20140729153607.GA10174@kroah.com>
References: <20140729173824.51e94ce2@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140729173824.51e94ce2@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 05:38:24PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the char-misc tree got a conflict in
> drivers/dma/Makefile between commit 555859308723 ("dmaengine: sun6i:
> Add driver for the Allwinner A31 DMA controller") from the slave-dma tree and
> commit 95b4ecbf759a ("dma: MIC X100 DMA Driver") from the char-misc
> tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good, thanks.

greg k-h
