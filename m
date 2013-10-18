Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638Ab3JRUt3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 16:49:29 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:43314 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab3JRUtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 16:49:25 -0400
Date: Fri, 18 Oct 2013 13:49:17 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/11] 3.4.67-stable review
Message-ID: <20131018204917.GA21100@roeck-us.net>
References: <20131018195049.069623827@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131018195049.069623827@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 12:53:29PM -0700, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.67 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun Oct 20 19:50:39 UTC 2013.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.67-rc1.gz
> and the diffstat can be found below.
> 
Build results:
	total: 103 pass: 89 skipped: 10 fail: 4

qemu tests all pass.

This matches the results seen with the previous 3.4 release, so everything
is as expected.

Details are available at http://server.roeck-us.net:8010/builders.

Thanks,
Guenter
