Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbaBTXXi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 18:23:38 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:53843 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462AbaBTXXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:23:36 -0500
Date: Thu, 20 Feb 2014 15:23:32 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.13 00/40] 3.13.4-stable review
Message-ID: <20140220232332.GA3584@roeck-us.net>
References: <20140218224433.337299968@linuxfoundation.org>
 <20140219043026.GA15371@roeck-us.net>
 <20140220183220.GD15290@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140220183220.GD15290@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 10:32:20AM -0800, Greg Kroah-Hartman wrote:
> On Tue, Feb 18, 2014 at 08:30:26PM -0800, Guenter Roeck wrote:
> > On Tue, Feb 18, 2014 at 02:47:01PM -0800, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 3.13.4 release.
> > > There are 40 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Thu Feb 20 22:44:22 UTC 2014.
> > > Anything received after that time might be too late.
> > > 
> > 
> > Build results:
> >     total: 126 pass: 122 skipped: 4 fail: 0
> > 
> > qemu tests all passed.
> > 
> > Details are available at http://server.roeck-us.net:8010/builders.
> > 
> > Results are as expected.
> 
> Thanks for testing and letting me know.  Interesting that the pstate
> buggy patch didn't hit your build system testing...
> 
Nothing is perfect :-(. You mean the one where your builder
takes much more time to build the kernel with the patch applied,
or was here another one ?

Guenter
