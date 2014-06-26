Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbaFZUeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 16:34:18 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:43617 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbaFZUeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 16:34:15 -0400
Date: Thu, 26 Jun 2014 13:34:11 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.15 00/61] 3.15.2-stable review
Message-ID: <20140626203411.GA19179@roeck-us.net>
References: <20140624154952.751713761@linuxfoundation.org>
 <53AA0A34.8080300@roeck-us.net>
 <20140626190913.GA5565@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140626190913.GA5565@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 03:09:13PM -0400, Greg Kroah-Hartman wrote:
> On Tue, Jun 24, 2014 at 04:31:00PM -0700, Guenter Roeck wrote:
> > On 06/24/2014 08:50 AM, Greg Kroah-Hartman wrote:
> > >This is the start of the stable review cycle for the 3.15.2 release.
> > >There are 61 patches in this series, all will be posted as a response
> > >to this one.  If anyone has any issues with these being applied, please
> > >let me know.
> > >
> > >Responses should be made by Thu Jun 26 15:49:36 UTC 2014.
> > >Anything received after that time might be too late.
> > >
> > 
> > Build results:
> > 	total: 144 pass: 136 skipped: 5 fail: 3
> > Failed builds:
> > 	powerpc:allmodconfig (binutils 2.23)
> > 	powerpc:allmodconfig (binutils 2.24)
> > 	unicore32:defconfig
> > 
> > Qemu tests all passed.
> > 
> > Results are as expected. Again, unicore32:defconfig would be an easy fix if so desired.
> 
> Thanks for testing all of these.
> 
> As the maintainer of the architecture doesn't seem to care about
> unicore32, I don't see the need to spend any time / effort on it either
> :(
> 
Well, at least it's building in mainline now. Of course, in a sense
you are right, it wasn't the maintainer providing the fixes.

Guenter
