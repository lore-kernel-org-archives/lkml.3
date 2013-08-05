Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421Ab3HEFYd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 01:24:33 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35092 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754135Ab3HEFYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 01:24:32 -0400
X-Sasl-enc: ak3vponKvy0DQz14DgV51/A7szYYc2shZy/UKCP6SRiK 1375680270
Date: Mon, 5 Aug 2013 13:25:48 +0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bastian Hecht <hechtb@gmail.com>, Jingoo Han <jg1.han@samsung.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: linux-next: manual merge of the tty tree with the sh tree
Message-ID: <20130805052548.GB31808@kroah.com>
References: <20130805150456.974461a9896ae4d61f044aab@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130805150456.974461a9896ae4d61f044aab@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 03:04:56PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the tty tree got a conflict in
> drivers/tty/serial/sh-sci.c between commit ada80ee7fa60 ("serial: sh-sci:
> Add OF support") from the sh tree and commit 3ba35baa55fa ("serial:
> sh-sci: use dev_get_platdata()") from the tty tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good to me, thanks.

greg k-h
