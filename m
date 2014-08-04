Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770AbaHDRzu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:55:50 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:37161 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaHDRzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 13:55:48 -0400
Date: Mon, 4 Aug 2014 10:55:44 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>, akpm@linux-foundation.org
Subject: Re: [PATCH 3.2 00/94] 3.2.62-rc1 review
Message-ID: <20140804175544.GA7631@roeck-us.net>
References: <lsq.1407170911.107020799@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 05:48:31PM +0100, Ben Hutchings wrote:
> This is the start of the stable review cycle for the 3.2.62 release.
> There are 94 patches in this series, which will be posted as responses
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed Aug 06 17:00:00 UTC 2014.
> Anything received after that time might be too late.
> 
Build results:
	total: 111 pass: 105 fail: 6
Failed builds:
	microblaze:mmu_defconfig
	microblaze:nommu_defconfig
	mips:allmodconfig
	sparc64:allmodconfig
	xtensa:defconfig
	xtensa:allmodconfig

Qemu tests all passed.

This is a significant improvement over the previous versions, where we used
to see up to 10 build failures. The previously failing builds for unicore32
and score now pass, as well as alpha:allmodconfig.

Note that I rearranged arm builds to improve test coverage.

Details are available at http://server.roeck-us.net:8010/builders.

Guenter
