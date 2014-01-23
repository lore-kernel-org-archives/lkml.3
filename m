Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650AbaAWXfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 18:35:54 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:36117 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027AbaAWXfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 18:35:53 -0500
Date: Thu, 23 Jan 2014 15:35:45 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.10 00/23] 3.10.28-stable review
Message-ID: <20140123233545.GA32121@roeck-us.net>
References: <20140123183859.635713053@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140123183859.635713053@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 10:39:33AM -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.28 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat Jan 25 18:38:43 UTC 2014.
> Anything received after that time might be too late.
> 
Build results are as expected:
	total: 126 pass: 121 skipped: 4 fail: 1

The failing build is avr32:atngw100mkii_evklcd101_defconfig.

qemu tests were all successful.

Details are available at http://server.roeck-us.net:8010/builders.

Thanks,
Guenter
