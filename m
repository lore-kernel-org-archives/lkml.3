Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321AbaJPHtM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 03:49:12 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:20116 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbaJPHtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 03:49:10 -0400
Date: Thu, 16 Oct 2014 10:48:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcm/CmHost.c: Fix noisy compile warnings
Message-ID: <20141016074827.GD23154@mwanda>
References: <1413375999-10210-1-git-send-email-jeffrey.t.kirsher@intel.com>
 <20141015123431.GA23154@mwanda>
 <20141015125934.GB23154@mwanda>
 <1413378213.2412.13.camel@jtkirshe-mobl>
 <1413389496.7484.3.camel@perches.com>
 <20141015195345.GQ26918@mwanda>
 <1413403429.7484.13.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413403429.7484.13.camel@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 01:03:49PM -0700, Joe Perches wrote:
> On Wed, 2014-10-15 at 22:53 +0300, Dan Carpenter wrote:
> > On Wed, Oct 15, 2014 at 09:11:36AM -0700, Joe Perches wrote:
> > > On Wed, 2014-10-15 at 06:03 -0700, Jeff Kirsher wrote:
> > > []
> > > > I thought I remember Greg saying something about getting rid of this
> > > > driver anyway, but I could be wrong.  If Greg decides to keep this
> > > > driver around, then I think we should something like your suggestion
> > > > above.
> > > 
> > > Or maybe just make the Kconfig depend on X86_32
> > 
> > What I like about your patches is that they are pure theoretical work
> > and I don't have to think about them like regular proper patches with a
> > signed off by etc.  All the fun, none of the responsibility.
> 
> I've sent a lot of signed-off patches.
> These are simple suggestions.
> 
> I think COMPILE_TEST isn't useful here.

I don't understand...  COMPILE_TEST means runing a static checker on
the driver.  Why would we not want to do QA?

regards,
dan carpenter

