Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632AbaGTVEv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 17:04:51 -0400
Received: from one.firstfloor.org ([193.170.194.197]:44688 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbaGTVEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 17:04:50 -0400
Date: Sun, 20 Jul 2014 23:04:48 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Greg KH <gregkh@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, davem@davemloft.net,
        sachin.kamat@linaro.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: staging/8821ae driver breaks allyes build in 3.16-rc*
Message-ID: <20140720210448.GM18735@two.firstfloor.org>
References: <20140720190523.GL18735@two.firstfloor.org>
 <20140720192511.GA3120@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140720192511.GA3120@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2014 at 12:25:11PM -0700, Greg KH wrote:
> On Sun, Jul 20, 2014 at 09:05:23PM +0200, Andi Kleen wrote:
> > 
> > Hi,
> > 
> > I cannot build make allyesconfig in current Linus mainline, because 
> > drivers/staging/rtl8821ae has a lot of compile errors.
> 
> allyesconfig should turn off the staging drivers, how did you turn it
> on?

I just ran allyesconfig, didnt do anything special.

-Andi
