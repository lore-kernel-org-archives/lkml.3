Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbaGTV72 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 17:59:28 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:53928 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750882AbaGTV7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 17:59:25 -0400
X-Sasl-enc: +DktcfMng8ErJLbxZoD6JugdMobjHscZYcbB7ze2O07k 1405893565
Date: Sun, 20 Jul 2014 14:59:24 -0700
From: Greg KH <gregkh@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: davem@davemloft.net, sachin.kamat@linaro.org,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: staging/8821ae driver breaks allyes build in 3.16-rc*
Message-ID: <20140720215924.GA6243@kroah.com>
References: <20140720190523.GL18735@two.firstfloor.org>
 <20140720192511.GA3120@kroah.com>
 <20140720193821.GA12357@kroah.com>
 <20140720194327.GA11230@kroah.com>
 <20140720212101.GN18735@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140720212101.GN18735@two.firstfloor.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2014 at 11:21:01PM +0200, Andi Kleen wrote:
> > Ok, that's odd, I thought we didn't build staging drivers for
> > allyesconfig, but you are right, we do.
> > 
> 
> It was changed a few kernels ago iirc.

I looked into this, it changed in 3.0, many _years_ ago, from a patch I
wrote... :)

> > allyesconfig builds the staging directory just fine for me here, with
> > Linus's current tree:
> 
> Ok I builds after I threw the old build directory away. Mysterious.

Ah, good, glad it's working for you now.

greg k-h
