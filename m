Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725AbaC2B00 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 21:26:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55247 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbaC2B0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 21:26:25 -0400
Date: Fri, 28 Mar 2014 18:28:19 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.13 00/46] 3.13.8-stable review
Message-ID: <20140329012819.GB14131@kroah.com>
References: <20140328173134.630198216@linuxfoundation.org>
 <53361DEC.4030306@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53361DEC.4030306@roeck-us.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2014 at 06:12:12PM -0700, Guenter Roeck wrote:
> On 03/28/2014 10:31 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.13.8 release.
> > There are 46 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun Mar 30 17:31:14 UTC 2014.
> > Anything received after that time might be too late.
> >
> 
> Build results:
> 	total: 126 pass: 120 skipped: 4 fail: 2
> 
> qemu tests all passed.
> 
> Builds powerpc:mpc85xx_defconfig and powerpc:mpc85xx_smp_defconfig
> are still failing. Upstream (-rc8) still has the same problem.
> Results are therefore as expected.
> 
> Details are available at http://server.roeck-us.net:8010/builders.

Wonderful, thanks for testing all 3 of these releases and letting me
know.

greg k-h
