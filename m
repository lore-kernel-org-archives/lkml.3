Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113AbaFFPcn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 11:32:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37453 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaFFPcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 11:32:41 -0400
Date: Fri, 6 Jun 2014 08:32:33 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.14 000/228] 3.14.6-stable review
Message-ID: <20140606153233.GC13635@kroah.com>
References: <20140604232347.966798903@linuxfoundation.org>
 <20140605232008.GB14136@kroah.com>
 <20140606075310.GC13355@roeck-us.net>
 <87d2emay69.wl%satoru.takeuchi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d2emay69.wl%satoru.takeuchi@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 11:51:42PM +0900, Satoru Takeuchi wrote:
> Hi Greg,
> 
> At Fri, 6 Jun 2014 00:53:10 -0700,
> Guenter Roeck wrote:
> > 
> > On Thu, Jun 05, 2014 at 04:20:08PM -0700, Greg Kroah-Hartman wrote:
> > > On Wed, Jun 04, 2014 at 04:20:29PM -0700, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 3.14.6 release.
> > > > There are 228 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > > 
> > > > Responses should be made by Fri Jun  6 23:23:11 UTC 2014.
> > > > Anything received after that time might be too late.
> > > > 
> > > > The whole patch series can be found in one patch at:
> > > > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.14.6-rc1.gz
> > > > and the diffstat can be found below.
> > > 
> > > I've updated the stable tree with the futex patches as lots of people
> > > have been asking me about them, so here is a -rc2 with them
> > > incorporated:
> > > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.14.6-rc1.gz
> 
> "s/-rc1/-rc2/" ? I used the following one.

Yes, sorry :(

> https://www.kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.14.6-rc2.xz
> 
> > > 
> > 
> > Build and qemu tests are still ok. Same applies to 3.4 and 3.10.
> 
> 3.14.6-rc2, 3.10.42-rc1, and 3.4.92-rc1 passed my test.
> 
>  - Test Cases:
>    - Build this kernel.
>    - Boot this kernel.
>    - Build the latest mainline kernel with this kernel.
> 
>  - Test Tool:
>    https://github.com/satoru-takeuchi/test-linux-stable
> 
>  - Test Result (kernel .config, ktest config and test log):
>    http://satoru-takeuchi.org/test-linux-stable/results/<version>-<test datetime>.tar.xz
> 
>  - Build Environment:
>    - OS: Debian Jessy x86_64
>    - CPU: Intel(R) Core(TM) i5-2400 CPU @ 3.10GHz x 4
>    - memory: 8GB
> 
>  - Test Target Environment:
>    - Debian Jessy x86_64 (KVM guest on the Build Environment)
>    - # of vCPU: 2
>    - memory: 2GB

Great, thanks for testing and letting me know.

greg k-h
