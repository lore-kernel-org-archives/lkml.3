Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab3ETG6x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 02:58:53 -0400
Received: from lan.nucleusys.com ([92.247.61.126]:49208 "EHLO
	zztop.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754751Ab3ETG6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 02:58:52 -0400
Date: Mon, 20 May 2013 09:58:39 +0300 (EEST)
From: Petko Manolov <petkan@nucleusys.com>
To: Francois Romieu <romieu@fr.zoreil.com>
cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] drivers: net: usb: rtl8150: bug fixing and cleanup
In-Reply-To: <20130519190116.GA4019@electric-eye.fr.zoreil.com>
Message-ID: <alpine.DEB.2.02.1305200941260.4719@fry.nucleusys.com>
References: <alpine.DEB.2.02.1305181902080.7518@fry.nucleusys.com> <20130518210948.GA26590@electric-eye.fr.zoreil.com> <alpine.DEB.2.02.1305191136360.4537@fry.nucleusys.com> <20130519190116.GA4019@electric-eye.fr.zoreil.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 19 May 2013, Francois Romieu wrote:

> Which one ?
> - share it through the kernel or with userspace
> - personal choice .c split

It is obviously not the former.  I think that in general constant and 
other definitions (in their majority) should be in a header file.  I 
definitely like this way better.

Perhaps in this particular case my patch is a bit of an overkill as the 
code lines aren't that many.  If the consensus is in this direction i'll 
revert this part of the series.

> I don't mind the later even if it does not exactly apply to a
> WIP driver. I'd still avoid future copycat followers though.

This isn't WIP anymore as the W(ork) part is missing.  After so many quiet 
years i assume the experimental tag should be removed.

> The rtl8150.h file is created in patch #2. This is patch #1.
> 
> So...

So first apply patch #1 and then patch #2.

However, if it is required for the driver to be in build-able form after 
applying any single patch i'll coalesce #1 and #2 before next submission.


David?


		Petko
