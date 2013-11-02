Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab3KBCaL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 22:30:11 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:60990 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037Ab3KBCaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 22:30:09 -0400
Date: Fri, 1 Nov 2013 19:30:07 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.10 00/54] 3.10.18-stable review
Message-ID: <20131102023007.GB20224@roeck-us.net>
References: <20131101220211.311926234@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131101220211.311926234@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01, 2013 at 03:03:28PM -0700, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.18 release.
> There are 54 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun Nov  3 22:00:53 UTC 2013.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.18-rc1.gz
> and the diffstat can be found below.
> 
Build results look good:
	total: 110 pass: 110 skipped: 0 fail: 0

qemu tests all pass.

Details are at http://server.roeck-us.net:8010/builders.

Thanks,
Guenter

