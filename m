Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbaIBMsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 08:48:11 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbaIBMsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 08:48:08 -0400
Message-ID: <5405BC83.8050801@nod.at>
Date: Tue, 02 Sep 2014 14:48:03 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Vishnu Pratap Singh <vishnu.ps@samsung.com>, akpm@linux-foundation.org,
        oleg@redhat.com, paulmck@linux.vnet.ibm.com, jkosina@suse.cz,
        fabf@skynet.be, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        cpgs@samsung.com
CC: pintu.k@samsung.com, vishu13285@gmail.com
Subject: Re: [PATCH] kernel/signal.c: whitespace fixes
References: <1409661657-7598-1-git-send-email-vishnu.ps@samsung.com>
In-Reply-To: <1409661657-7598-1-git-send-email-vishnu.ps@samsung.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Am 02.09.2014 14:40, schrieb Vishnu Pratap Singh:
> From: "vishnu.ps" <vishnu.ps@samsung.com>
> 
> Fix minor errors and warning messages in kernel/signal.c.  These errors were
> reported by checkpatch while working with some modifications in signal.c
> file.
> 
> ERROR: code indent should use tabs where possible - 18
> ERROR: need consistent spacing around '&' (ctx:WxO) - 11
> ERROR: space prohibited after that '~' (ctx:OxW) - 11
> ERROR: trailing whitespace - 4
> ERROR: space required after that ',' (ctx:VxV) - 4
> ERROR: trailing statements should be on next line - 3
> ERROR: "foo * bar" should be "foo *bar" - 1
> 
> total 52 errors fixed.

Please don't run checkpatch.pl on in-kernel files.
The tool is designed to check patches, not files.
Such whitespace cleanups pollute the kernel history, i.e. such that
git blame returns false positives.

The purpose of --file is:
- Checking out-of-tree files (like existing drivers to be imported)
- One notable exception is drivers/staging/, you can run it on these files.

Thanks,
//richard
