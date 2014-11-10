Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626AbaKJFg4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 00:36:56 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:43084 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751152AbaKJFgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 00:36:54 -0500
X-Sasl-enc: fCGHtbccomlgziQ+J/NPfkUi2gopXlC+8NtW4BvbEnpE 1415597812
Date: Mon, 10 Nov 2014 14:08:04 +0900
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Eddie Huang <eddie.huang@mediatek.com>
Subject: Re: linux-next: manual merge of the tty tree with the tty.current
 tree
Message-ID: <20141110050804.GB16980@kroah.com>
References: <20141110154958.5729e46e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141110154958.5729e46e@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 03:49:58PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the tty tree got a conflict in
> drivers/tty/serial/8250/8250_mtk.c between commit cd92208f6996 ("tty:
> serial: 8250_mtk: Fix quot calculation") from the tty.current tree and
> commit 2a768264eef0 ("tty: serial: Fix mediatek UART driver setting
> baudrate issue") from the tty tree.
> 
> I fixed it up (I just used the version from the tty tree) and can carry
> the fix as necessary (no action is required).

Thanks, I've already resolved this in the tree, so you will not need
this tomorrow.

greg k-h
