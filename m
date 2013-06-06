Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932514Ab3FFIgy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 04:36:54 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:33004 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932240Ab3FFIgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 04:36:52 -0400
Date: Thu, 6 Jun 2013 11:38:40 +0300
From: Timo Teras <timo.teras@iki.fi>
To: Chris Boot <bootc@bootc.net>
Cc: Fan Du <fan.du@windriver.com>, Jean Sacren <sakiwit@gmail.com>,
        steffen.klassert@secunet.com, herbert@gondor.hengli.com.au,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: PANIC at net/xfrm/xfrm_output.c:125 (3.9.4)
Message-ID: <20130606113840.511a72c3@vostro>
In-Reply-To: <51B03EAC.6080508@bootc.net>
References: <51AFB204.8070009@bootc.net>
	<20130606010416.GF26681@mail.gmail.com>
	<51AFE4C2.1000604@windriver.com>
	<51B03EAC.6080508@bootc.net>
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Jun 2013 08:47:56 +0100
Chris Boot <bootc@bootc.net> wrote:

> On 06/06/13 02:24, Fan Du wrote:
> > Hello Chris/Jean
> > 
> > This issue might have already been fixed by this:
> > https://git.kernel.org/cgit/linux/kernel/git/davem/net-next.git/commit/net/xfrm/xfrm_output.c?id=497574c72c9922cf20c12aed15313c389f722fa0
> > 
> > 
> > Hope it helps.
> 
> Hi Fan, Jean,
> 
> Thanks, that looks like it's the patch for exactly my problem.
> Unfortunately I can't test it until next week now. :-/
> 
> Timo/Dave: are there any plans to push this into 3.10-rc and/or
> stable? I seem to be able to hit the issue pretty reliably.

It is already present in 3.10-rc3 [1], and Dave has it queued for
3.9-stable [2].

- Timo

[1] http://lwn.net/Articles/551922/
[2] http://patchwork.ozlabs.org/patch/245594/
