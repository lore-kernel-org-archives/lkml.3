Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330Ab3LSUNn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 15:13:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45821 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755704Ab3LSUNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 15:13:42 -0500
Date: Thu, 19 Dec 2013 12:13:45 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.4 00/31] 3.4.75-stable review
Message-ID: <20131219201345.GA26827@kroah.com>
References: <20131218210522.790152625@linuxfoundation.org>
 <20131219195446.GB27311@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131219195446.GB27311@roeck-us.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 11:54:46AM -0800, Guenter Roeck wrote:
> On Wed, Dec 18, 2013 at 01:08:08PM -0800, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.4.75 release.
> > There are 31 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri Dec 20 21:05:11 UTC 2013.
> > Anything received after that time might be too late.
> > 
> My builder noticed that you added one more patch to all releases
> and triggered a rebuild.
> 
> v3.4.74-32:	total: 103 pass: 89 skipped: 10 fail: 4
> v3.10.24-79:	total: 110 pass: 109 skipped: 0 fail: 1
> v3.12.5-119:	total: 110 pass: 107 skipped: 3 fail: 0
> 
> Everything still as expected, with all qemu tests passed as well.

Thanks, yes, there was a missing patch for one of the various omap
patches that needed to be included, thanks for testing and verifying
nothing broke.

greg k-h
