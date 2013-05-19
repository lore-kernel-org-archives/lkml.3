Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab3ESI1r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 04:27:47 -0400
Received: from lan.nucleusys.com ([92.247.61.126]:49151 "EHLO
	zztop.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753645Ab3ESI1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 04:27:43 -0400
Date: Sun, 19 May 2013 11:27:29 +0300 (EEST)
From: Petko Manolov <petkan@nucleusys.com>
To: Francois Romieu <romieu@fr.zoreil.com>
cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] drivers: net: usb: rtl8150: bug fixing and code
 cleanup
In-Reply-To: <20130518212013.GA26921@electric-eye.fr.zoreil.com>
Message-ID: <alpine.DEB.2.02.1305191121400.4537@fry.nucleusys.com>
References: <alpine.DEB.2.02.1305182305110.16874@fry.nucleusys.com> <20130518212013.GA26921@electric-eye.fr.zoreil.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 May 2013, Francois Romieu wrote:

> Petko Manolov <petkan@nucleusys.com> :
> [...]
> > This patch series adds rtl8150.h, which contains structure and constant 
> > definitons formerly found in rtl8150.c, removes socket buffer 
> > pre-allocated pool and uses dynamically allocated memory for the 
> > asynchronous URB requests, thus avoids clobbering the previously scheduled 
> > for update value.
> > 
> > This patch series is against 'net' tree.
> 
> 'net' tree takes fixes. The cleanup / fix ratio is imho a bit high in 
> this series. You may submit the fix part now and wait until davem merges 
> 'net' into 'net-next' to submit big cleanups against net-next.

Well, i did ask which tree to use as a base.  It may seem like a lot, but 
these changes are trivial.  If David decide to schedule the patches for 
3.11 it won't break my heart.


		Petko
