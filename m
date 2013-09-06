Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668Ab3IFQjM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 12:39:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33638 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756210Ab3IFQjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 12:39:11 -0400
Date: Fri, 6 Sep 2013 09:39:09 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 0/7] 3.0.95-stable review
Message-ID: <20130906163909.GA17541@kroah.com>
References: <20130905202757.642048278@linuxfoundation.org>
 <20130905225442.GA1358@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130905225442.GA1358@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 03:54:42PM -0700, Guenter Roeck wrote:
> On Thu, Sep 05, 2013 at 01:28:33PM -0700, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.0.95 release.
> > There are 7 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat Sep  7 20:27:46 UTC 2013.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.95-rc1.gz
> > and the diffstat can be found below.
> > 
> buildbot says:
> 	total: 88 pass: 63 skipped: 11 fail: 14
> which, while not perfect, matches the test results for the previous release.
> 
> qemu test runs for ppc, x86, and x86_64 are also fine.

Thanks for testing and letting me know.

greg k-h
