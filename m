Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab3H0WZG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 18:25:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42403 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab3H0WZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 18:25:04 -0400
Date: Tue, 27 Aug 2013 15:27:20 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/74] 3.10.10-stable review
Message-ID: <20130827222720.GA27592@kroah.com>
References: <20130827010424.535365435@linuxfoundation.org>
 <521C2BA7.2010705@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521C2BA7.2010705@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 09:31:35PM -0700, Guenter Roeck wrote:
> On 08/26/2013 06:07 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.10.10 release.
> > There are 74 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu Aug 29 01:03:56 UTC 2013.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.10-rc1.gz
> > and the diffstat can be found below.
> >
> 
> Cross build results:
> 	total: 85 pass: 85 fail: 0
> Compared to 3.10.8:
> 	total: 76 pass: 76 fail: 0
> 
> qemu tests:
> 	arm, microblaze, mips, mips64, ppc, x86, x86_64: pass (boot to login prompt)
> 	
> Note that the arm qemu test now passes because I found a workaround for the bug
> causing the failure observed with the previous release, not because the bug was fixed.

Ah, but at least it doesn't fail now :)

> More builds, more platforms tested, still no failures. Results look good.

Thanks for testing all 3 of these kernels and letting me know.

greg k-h
