Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997AbaJEVrr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 17:47:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34399 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbaJEVro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 17:47:44 -0400
Date: Sun, 5 Oct 2014 14:47:43 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Chuck Ebbert <cebbert.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3.16 000/357] 3.16.4-stable review
Message-ID: <20141005214743.GB20113@kroah.com>
References: <20141003212933.458851516@linuxfoundation.org>
 <20141004073839.125fa529@as>
 <20141005203914.GE2528@kroah.com>
 <20141005155057.4a2c5a99@as>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141005155057.4a2c5a99@as>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 05, 2014 at 03:50:57PM -0500, Chuck Ebbert wrote:
> On Sun, 5 Oct 2014 13:39:14 -0700
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
> > On Sat, Oct 04, 2014 at 07:38:39AM -0500, Chuck Ebbert wrote:
> > > On Fri,  3 Oct 2014 14:26:26 -0700
> > > Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > > 
> > > > ---------------------------------
> > > > Note: This is a big stable release.  Mostly my fault for being on the
> > > > road last week, combined with an unusually large number of patches being
> > > > tagged for the stable tree.  Anyway, I've caught up with all pending
> > > > patches before 3.17-rc7, so if you have marked something for the stable
> > > > tree that I have not applied, or emailed the stable@v.k.o list asking
> > > > for a patch, that is not here, please let me know.
> > > > ---------------------------------
> > > > 
> > > > This is the start of the stable review cycle for the 3.16.4 release.
> > > > There are 357 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > > 
> > > > Responses should be made by Sun Oct  5 21:28:42 UTC 2014.
> > > > Anything received after that time might be too late.
> > > > 
> > > 
> > > Should also include this one, which fixes CVE-2014-6410:
> > > 
> > > commit c03aa9f6e1f938618e6db2e23afef0574efeeb65
> > > Author: Jan Kara <jack@suse.cz>
> > > Date:   Thu Sep 4 14:06:55 2014 +0200
> > > 
> > >     udf: Avoid infinite loop when processing indirect ICBs
> > 
> > Thanks, I'll queue that up for the next stable releases.
> > 
> > greg k-h
> 
> I built 3.16.4-rc1 for Fedora, which already has this patch included.
> 
> It boots and runs on Fedora 21, and that patch has been in Fedora 21 for
> a while. Why not include it in 3.16.4?

Because I found out about it _after_ 3.16-rc4 was released for review,
with 357 other patches in it.  What's so pressing with this that can't
wait a few more days?

greg k-h
