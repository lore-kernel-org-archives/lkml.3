Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab3IIRIY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 13:08:24 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:63958 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab3IIRIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 13:08:23 -0400
Date: Mon, 9 Sep 2013 10:08:19 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, Peng Tao <tao.peng@emc.com>,
        Peng Tao <bergwolf@gmail.com>
Subject: Re: [PATCH] staging: Disable lustre file system for MIPS, SH, and
 XTENSA
Message-ID: <20130909170819.GA22764@roeck-us.net>
References: <1378688580-11935-1-git-send-email-linux@roeck-us.net>
 <20130909015945.GA4029@kroah.com>
 <20130909134012.GA24738@infradead.org>
 <20130909163902.GA28685@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909163902.GA28685@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 09:39:02AM -0700, Greg Kroah-Hartman wrote:
> On Mon, Sep 09, 2013 at 06:40:12AM -0700, Christoph Hellwig wrote:
> > On Sun, Sep 08, 2013 at 06:59:45PM -0700, Greg Kroah-Hartman wrote:
> > > Can't we just export the functions for those arches?  Surely lutre
> > > isn't the first/only driver that needs this?
> > 
> > Lustre is.  These are core mm helpers, and lustre uses them to
> > reimplement another core VM function.  It then uses it to access
> > userspace environment variable.
> > 
> > In short all this code should be nuked, and no new symbols should be
> > exported.
> 
> Ugh, you are right, the lustre code needs to be fixed here.
> 
Given that, should I send another patch marking it as BROKEN again ?

Guenter
