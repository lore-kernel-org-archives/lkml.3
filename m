Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934095AbaJ2PmB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 11:42:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43960 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934071AbaJ2Pl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 11:41:59 -0400
Date: Wed, 29 Oct 2014 16:40:40 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Eric Rost <eric.rost@mybabylon.net>, devel@driverdev.osuosl.org,
        antonysaraev@gmail.com, linux-kernel@vger.kernel.org, jake@lwn.net
Subject: Re: [PATCH v6 0/7] staging: skein: CryptoAPI and Module Support
Message-ID: <20141029084040.GA5333@kroah.com>
References: <cover.1414189566.git.eric.rost@mybabylon.net>
 <20141027132031.GB15252@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141027132031.GB15252@titan.lakedaemon.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 09:20:31AM -0400, Jason Cooper wrote:
> Greg,
> 
> On Fri, Oct 24, 2014 at 05:29:09PM -0500, Eric Rost wrote:
> > Adds CryptoAPI and loadable module support to the Skein Hashing
> > Algorithm. Collapses threefish module into skein module. Renames skein.c
> > and skein.h to skein_base.c and skein_base.h so module can be named
> > skein.ko. Inlines rotl_64 macro. Removes unneeded #define and
> > skein_debug.h include.
> > 
> > Eric Rost (7):
> >   staging: skein: Collapses threefish module
> >   staging: skein: Renames skein to skein_base
> >   staging: skein: Adds CryptoAPI Support
> >   staging: skein: Adds Loadable Module Support
> >   staging: skein: Inlines rotl_64
> >   staging: skein: Removes unneeded #define
> 
> For patches 1 through 6,
> 
> Reviewed-by: Jason Cooper <jason@lakedaemon.net>
> 
> We'll keep working on #7, but feel free to take the first six when you
> get a moment Greg.

Now applied, thanks.

greg k-h
