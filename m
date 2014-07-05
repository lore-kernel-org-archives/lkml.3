Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760215AbaGEARw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 20:17:52 -0400
Received: from mail.eperm.de ([89.247.134.16]:51247 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753729AbaGEARv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 20:17:51 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Joe Perches <joe@perches.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        kbuild test robot <fengguang.wu@intel.com>, kbuild@01.org,
        linux-crypto@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] DRBG: Fix format string for debugging statements
Date: Sat, 05 Jul 2014 02:15:46 +0200
Message-ID: <3976291.2Ne0xJphcZ@myon.chronox.de>
User-Agent: KMail/4.12.5 (Linux/3.14.9-200.fc20.x86_64; KDE/4.12.5; x86_64; ; )
In-Reply-To: <1404518973.6384.30.camel@joe-AO725>
References: <4927386.WYHrRe3NJm@myon.chronox.de> <3856718.HehN4Xqlpl@myon.chronox.de> <1404518973.6384.30.camel@joe-AO725>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 4. Juli 2014, 17:09:33 schrieb Joe Perches:

Hi Joe,

> On Sat, 2014-07-05 at 01:57 +0200, Stephan Mueller wrote:
> > And I also get the same output. Yet I am not sure how that code can be
> > compared to the code in the kernel.
> 
> What that code shows is that the ARRAY_SIZE
> type is size_t.
> 
> The difference is ARRAY_SIZE in the kernel
> should be output with %zu.

Using %zu works without a warning on my 64 bit machine. So you are saying that 
ARRAY_SIZE will always be size_t on every architecture? If yes, I will update 
my patch.


-- 
Ciao
Stephan
