Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713AbaJHQep (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 12:34:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47210 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbaJHQen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 12:34:43 -0400
Date: Wed, 8 Oct 2014 09:34:42 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Satoru Takeuchi <satoru.takeuchi@gmail.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.16 00/26] 3.16.5-stable review
Message-ID: <20141008163442.GA29773@kroah.com>
References: <20141007231848.487609292@linuxfoundation.org>
 <5434A5B1.9010408@roeck-us.net>
 <20141008044803.GC26820@kroah.com>
 <87r3yihh0p.wl%satoru.takeuchi@gmail.com>
 <20141008133252.GD5119@kroah.com>
 <20141008154929.GA12647@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141008154929.GA12647@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 08:49:47AM -0700, Guenter Roeck wrote:
> On Wed, Oct 08, 2014 at 06:32:52AM -0700, Greg Kroah-Hartman wrote:
> > On Wed, Oct 08, 2014 at 09:39:50PM +0900, Satoru Takeuchi wrote:
> > > At Tue, 7 Oct 2014 21:48:04 -0700,
> > > Greg Kroah-Hartman wrote:
> > > > 
> > > > On Tue, Oct 07, 2014 at 07:47:13PM -0700, Guenter Roeck wrote:
> > > > > On 10/07/2014 04:19 PM, Greg Kroah-Hartman wrote:
> > > > > >This is the start of the stable review cycle for the 3.16.5 release.
> > > > > >There are 26 patches in this series, all will be posted as a response
> > > > > >to this one.  If anyone has any issues with these being applied, please
> > > > > >let me know.
> > > > > >
> > > > > >Responses should be made by Thu Oct  9 23:18:40 UTC 2014.
> > > > > >Anything received after that time might be too late.
> > > > > >
> > > > > 
> > > > > Build results:
> > > > > 	total: 136 pass: 136 fail: 0
> > > > > Qemu tests:
> > > > > 	total: 30 pass: 30 fail: 0
> > > > > 
> > > > > Details are available at http://server.roeck-us.net:8010/builders.
> > > > 
> > > > Wonderful, thanks for testing all 3 of these and letting me know.
> > > 
> > > Plus, all these kernels passed my test.
> > > 
> > >  - Test Cases:
> > >    - Build this kernel.
> > >    - Boot this kernel.
> > >    - Build the latest mainline kernel with this kernel.
> > > 
> > >  - Test Tool:
> > >    https://github.com/satoru-takeuchi/test-linux-stable
> > > 
> > >  - Test Result (kernel .config, ktest config and test log):
> > >    http://satoru-takeuchi.org/test-linux-stable/results/<version>-<test datetime>.tar.xz
> > > 
> > >  - Build Environment:
> > >    - OS: Debian Jessy x86_64
> > >    - CPU: Intel(R) Core(TM) i5-2400 CPU @ 3.10GHz x 4
> > >    - memory: 8GB
> > > 
> > >  - Test Target Environment:
> > >    - Debian Jessy x86_64 (KVM guest on the Build Environment)
> > >    - # of vCPU: 2
> > >    - memory: 2GB
> > 
> > Glad to hear it, I was worried about 3.14, thanks for testing and
> > verifying I didn't mess anything up.
> > 
> Anything special to be worried about for 3.14.20 that might warrant
> further / special testing ?

If it boots, it's good :)

> FWIW, I merged 3.14.19 into our target kernel. It does pass smoketest ;-).

Good, I merged a bunch of mm patches that Mel backported for 3.12.  I
have more to do, was doing them in batches to try to make bisection
easier if problems show up.

thanks,

greg k-h
