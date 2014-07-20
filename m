Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341AbaGTVVH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 17:21:07 -0400
Received: from one.firstfloor.org ([193.170.194.197]:44723 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbaGTVVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 17:21:03 -0400
Date: Sun, 20 Jul 2014 23:21:01 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Greg KH <gregkh@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, davem@davemloft.net,
        sachin.kamat@linaro.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: staging/8821ae driver breaks allyes build in 3.16-rc*
Message-ID: <20140720212101.GN18735@two.firstfloor.org>
References: <20140720190523.GL18735@two.firstfloor.org>
 <20140720192511.GA3120@kroah.com>
 <20140720193821.GA12357@kroah.com>
 <20140720194327.GA11230@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140720194327.GA11230@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ok, that's odd, I thought we didn't build staging drivers for
> allyesconfig, but you are right, we do.
> 

It was changed a few kernels ago iirc.


> allyesconfig builds the staging directory just fine for me here, with
> Linus's current tree:

Ok I builds after I threw the old build directory away. Mysterious.

Sorry for the false alarm.

-Andi
