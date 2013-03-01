Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751221Ab3CAMmX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 07:42:23 -0500
Received: from zimbra.linbit.com ([212.69.161.123]:54067 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab3CAMmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 07:42:21 -0500
X-Greylist: delayed 482 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Mar 2013 07:42:21 EST
Date: Fri, 1 Mar 2013 13:34:16 +0100
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com
Subject: Re: [Drbd-dev] linux-next: Tree for Feb 23 (drbd)
Message-ID: <20130301123416.GO2696@soda.linbit>
Mail-Followup-To: Randy Dunlap <rdunlap@infradead.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com
References: <20130225160038.d7f80aca93b62bd818c6b650@canb.auug.org.au>
 <512BBB43.8060309@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <512BBB43.8060309@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 11:28:03AM -0800, Randy Dunlap wrote:
> On 02/24/13 21:00, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Please do not add any work destined for v3.10 to your -next included
> > branches until after Linus has release v3.9-rc1.
> > 
> > Changes since 20130222:
> > 
> 
> 
> on i386:
> 
>   CC [M]  drivers/block/drbd/drbd_receiver.o
> drivers/block/drbd/drbd_receiver.c: In function 'drbd_do_auth':
> drivers/block/drbd/drbd_receiver.c:4662:10: error: 'mdev' undeclared (first use in this function)
> make[4]: *** [drivers/block/drbd/drbd_receiver.o] Error 1
> 
> 
> Full randconfig file is attached.

see: https://lkml.org/lkml/2013/2/5/375
and:
http://git.drbd.org/gitweb.cgi?p=linux-drbd.git;a=commitdiff;h=23c275cba16615ac8cd3815cb1a86fd64cf12aa6

> # CONFIG_CRYPTO_HMAC is not set

	Lars

