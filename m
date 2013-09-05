Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701Ab3IEW7l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 18:59:41 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:54458 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758580Ab3IEW7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 18:59:25 -0400
Date: Thu, 5 Sep 2013 15:59:22 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/36] 3.10.11-stable review
Message-ID: <20130905225922.GC1358@roeck-us.net>
References: <20130905202702.289738686@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130905202702.289738686@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 01:27:29PM -0700, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.11 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat Sep  7 20:26:25 UTC 2013.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.11-rc1.gz
> and the diffstat can be found below.
> 
buildbot says:
        total: 100 pass: 100 skipped: 0 fail: 0
Just like the previous release, this is a perfect result. Time to add some
failing builds to raise the challenge ?

qemu test runs for arm, microblaze, mips, mips64, ppc, x86, and x86_64 are fine.

Details are available at http://server.roeck-us.net:8010/builders.
	        
Guenter
