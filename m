Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbaHEPaa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 11:30:30 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45820 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753300AbaHEPa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 11:30:29 -0400
X-Sasl-enc: rLeedx8RbO9aKUa8GRUaYZ1CCt3gPvyr4fgs/Xse5fjc 1407252628
Date: Tue, 5 Aug 2014 08:29:56 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>, Vinod Koul <vinod.koul@intel.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Siva Yerramreddy <yshivakrishna@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: linux-next: manual merge of the char-misc tree with the
 slave-dma tree
Message-ID: <20140805152956.GA29841@kroah.com>
References: <20140805162843.054e1383@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140805162843.054e1383@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2014 at 04:28:43PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the char-misc tree got a conflict in
> drivers/dma/Makefile between commit b45b262cefd5 ("dmaengine: add a
> driver for AMBA AXI NBPF DMAC IP cores") from the slave-dma tree and
> commit 95b4ecbf759a ("dma: MIC X100 DMA Driver") from the char-misc
> tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good, thanks.

greg k-h
