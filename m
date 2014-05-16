Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560AbaEPP4C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 11:56:02 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:33536 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757375AbaEPPz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 11:55:59 -0400
Date: Fri, 16 May 2014 08:55:47 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>, akpm@linux-foundation.org
Subject: Re: [PATCH 3.2 00/34] 3.2.59-rc1 review
Message-ID: <20140516155547.GA32499@roeck-us.net>
References: <lsq.1400244440.390103756@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lsq.1400244440.390103756@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 01:47:20PM +0100, Ben Hutchings wrote:
> This is the start of the stable review cycle for the 3.2.59 release.
> There are 34 patches in this series, which will be posted as responses
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun May 18 12:47:20 UTC 2014.
> Anything received after that time might be too late.
> 
Build results:
	total: 131 pass: 97 skipped: 23 fail: 11

qemu tests all passed.

Build results look worse than usual, but that is due to changes in
my test environment, not due to changes in the code.

powerpc:allmodconfig fails because it is now build it with gcc 4.8.1.
You'll need to pull in commit 8fe9c93e7 (powerpc: Add vr save/restore
functions) to fix this problem.

powerpc:allmodconfig and powerpc:ppc64e_defconfig fail if built with binutils
2.24 due to a changed ABI in the powerpc assembler. This currently fails with
all releases; a patch to solve the problem is pending acceptance and upstream
integration.

unicore32:defconfig fails to build with all releases.

Details are available at http://server.roeck-us.net:8010/builders.

On a side note, can you add my e-mail (linux@roeck-us.net) to Cc: for the
review request e-mail ?

Thanks,
Guenter
