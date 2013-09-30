Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab3I3Bun (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 21:50:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33438 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456Ab3I3BuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 21:50:21 -0400
Date: Sun, 29 Sep 2013 18:50:22 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/22] 3.4.64-stable review
Message-ID: <20130930015022.GB13344@kroah.com>
References: <20130929191158.889693326@linuxfoundation.org>
 <5248D32A.40203@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5248D32A.40203@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 29, 2013 at 06:26:02PM -0700, Guenter Roeck wrote:
> On 09/29/2013 12:26 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.4.64 release.
> > There are 22 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Tue Oct  1 19:11:47 UTC 2013.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.64-rc1.gz
> > and the diffstat can be found below.
> >
> 
> Build test results:
> 	total: 103 pass: 89 skipped: 10 fail: 4
> 
> qemu:
> 	microblaze, mips, mips64, ppc, sh, sparc, x86, x86_64 pass.
> 	arm, sparc64 skipped
> 
> Same results as with 3.4.63.

Nice, thanks for testing and letting me know.

greg k-h
