Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027Ab3IEWyv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 18:54:51 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:60378 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757738Ab3IEWyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 18:54:45 -0400
Date: Thu, 5 Sep 2013 15:54:42 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 0/7] 3.0.95-stable review
Message-ID: <20130905225442.GA1358@roeck-us.net>
References: <20130905202757.642048278@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130905202757.642048278@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 01:28:33PM -0700, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.0.95 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat Sep  7 20:27:46 UTC 2013.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.95-rc1.gz
> and the diffstat can be found below.
> 
buildbot says:
	total: 88 pass: 63 skipped: 11 fail: 14
which, while not perfect, matches the test results for the previous release.

qemu test runs for ppc, x86, and x86_64 are also fine.

Details, for those who are interested, are available at
http://server.roeck-us.net:8010/builders.

Guenter
