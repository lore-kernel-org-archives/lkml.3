Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758782Ab3IEXBC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 19:01:02 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:61155 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758404Ab3IEW4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 18:56:31 -0400
Date: Thu, 5 Sep 2013 15:56:28 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/14] 3.4.61-stable review
Message-ID: <20130905225628.GB1358@roeck-us.net>
References: <20130905202614.354156084@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130905202614.354156084@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 01:28:11PM -0700, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.61 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat Sep  7 20:25:41 UTC 2013.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.61-rc1.gz
> and the diffstat can be found below.
> 

buildbot says:
        total: 93 pass: 80 skipped: 8 fail: 5
This matches the test results for the previous release.

qemu test runs for microblaze, mips, mips64, ppc, x86, and x86_64 are also fine.

Details are available at http://server.roeck-us.net:8010/builders.

Guenter
