Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848Ab3JCVTc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 17:19:32 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:53738 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755266Ab3JCVTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 17:19:30 -0400
Date: Thu, 3 Oct 2013 14:19:24 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/16] 3.4.65-stable review
Message-ID: <20131003211924.GB12828@roeck-us.net>
References: <20131003040445.523176877@linuxfoundation.org>
 <524D7167.9020809@roeck-us.net>
 <20131003184023.GA8901@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131003184023.GA8901@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 11:40:23AM -0700, Greg Kroah-Hartman wrote:
> On Thu, Oct 03, 2013 at 06:30:15AM -0700, Guenter Roeck wrote:
> > On 10/02/2013 09:05 PM, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 3.4.65 release.
> > > There are 16 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Sat Oct  5 04:04:34 UTC 2013.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.65-rc1.gz
> > > and the diffstat can be found below.
> > >
> > 
> > Build results:
> > 	total: 103 pass: 17 skipped: 10 fail: 76
> > 
> > Apparently due to:
> > 	mm: fix aio performance regression for database caused by THP
> 
> These build issues should be fixed with -rc2, if not, please let me
> know.
> 
Updated build results:
	total: 103 pass: 89 skipped: 10 fail: 4

qemu tests all pass.

This matches the results from 3.4.64.

Thanks,
Guenter
