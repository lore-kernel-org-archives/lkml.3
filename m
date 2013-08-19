Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750754Ab3HSD3E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 23:29:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46347 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab3HSD3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 23:29:01 -0400
Date: Sun, 18 Aug 2013 20:30:48 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/45] 3.10.8-stable review
Message-ID: <20130819033048.GB21419@kroah.com>
References: <20130818203620.996166594@linuxfoundation.org>
 <52117836.4090609@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52117836.4090609@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 18, 2013 at 06:43:18PM -0700, Guenter Roeck wrote:
> On 08/18/2013 01:35 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.10.8 release.
> > There are 45 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Tue Aug 20 20:36:09 UTC 2013.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.8-rc1.gz
> > and the diffstat can be found below.
> >
> 
> Cross build results:
> 	Total builds: 76 Total build errors: 0
> Previous release:
> 	Total builds: 69 Total build errors: 0
> 
> qemu:
> 	mips, ppc, x86, x86_64 pass (boot to login prompt)
> 	arm: fail (known problem, see https://lkml.org/lkml/2013/8/11/41)
> 
> More builds, still no failures.

Thanks for testing all 3 of these releases and letting me know all is
well.

greg k-h
