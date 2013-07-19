Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab3GSXuZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 19:50:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53135 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab3GSXtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 19:49:41 -0400
Date: Fri, 19 Jul 2013 16:45:21 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for May 2 (platform/x86/samsung-laptop)
Message-ID: <20130719234521.GB3264@kroah.com>
References: <20130502173537.c8aa671a1b22abe2ec341b87@canb.auug.org.au>
 <5182DA15.6030901@infradead.org>
 <51E97512.4040500@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E97512.4040500@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 10:19:14AM -0700, Randy Dunlap wrote:
> On 05/02/13 14:26, Randy Dunlap wrote:
> > On 05/02/13 00:35, Stephen Rothwell wrote:
> >> Hi all,
> >>
> >> Please do not add any v3.11 destined work to your linux-next included
> >> branches until after v3.10-rc1 is released.
> >>
> >> Changes since 20130501:
> >>
> > 
> > 
> > when CONFIG_ACPI_VIDEO=m and CONFIG_SAMSUNG_LAPTOP=y:
> > 
> > drivers/built-in.o: In function `samsung_init':
> > samsung-laptop.c:(.init.text+0x94ba): undefined reference to `acpi_video_unregister'
> > 
> > 
> > 
> 
> This build error still happens in linux-next of 20130719...

I have not been the samsung-laptop driver maintainer for a few years
now, so there's nothing I can do about this, sorry.

greg k-h
