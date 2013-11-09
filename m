Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756Ab3KIRKu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 12:10:50 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:64379 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756290Ab3KIRKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 12:10:25 -0500
Date: Sat, 9 Nov 2013 09:12:52 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.11 00/94] 3.11.8-stable review
Message-ID: <20131109171252.GC27366@kroah.com>
References: <20131109065204.252462489@linuxfoundation.org>
 <20131109170028.GA14421@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131109170028.GA14421@roeck-us.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 09, 2013 at 09:00:28AM -0800, Guenter Roeck wrote:
> On Fri, Nov 08, 2013 at 10:51:06PM -0800, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.11.8 release.
> > There are 94 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Mon Nov 11 06:51:44 UTC 2013.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.11.8-rc1.gz
> > and the diffstat can be found below.
> > 
> 
> Build test results look good:
> 	total: 110 pass: 108 skipped: 2 fail: 0
> 
> qemu tests all pass.

Wonderful, thanks for testing and letting me know.

greg k-h
