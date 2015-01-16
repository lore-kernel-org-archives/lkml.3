Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbbAPHQR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 02:16:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51569 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbbAPHQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 02:16:16 -0500
Date: Fri, 16 Jan 2015 09:16:00 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Amit Shah <amit.shah@redhat.com>, Amos Kong <akong@redhat.com>,
        Sasha Levin <sasha.levin@oracle.com>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] virtio_rng: drop extra empty line
Message-ID: <20150116071600.GA12274@redhat.com>
References: <1421322638-21320-1-git-send-email-mst@redhat.com>
 <20150115232109.GA5626@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150115232109.GA5626@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 10:21:09AM +1100, Herbert Xu wrote:
> On Thu, Jan 15, 2015 at 01:50:42PM +0200, Michael S. Tsirkin wrote:
> > makes code look a bit prettier.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> Please resend this patch with a cc to linux-crypto@vger.kernel.org.
> 
> Thanks!

So let's add this to maintainers?
Will you ack something like below?

--->


MAINTAINERS: add linux-crypto to hw random

hw random is crypto-related, Cc the linux-crypto list
on patches.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>


diff --git a/MAINTAINERS b/MAINTAINERS
index 3589d67..4d54f2e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4403,6 +4403,7 @@ F:	include/linux/hwmon*.h
 HARDWARE RANDOM NUMBER GENERATOR CORE
 M:	Matt Mackall <mpm@selenic.com>
 M:	Herbert Xu <herbert@gondor.apana.org.au>
+L:	linux-crypto@vger.kernel.org
 S:	Odd fixes
 F:	Documentation/hw_random.txt
 F:	drivers/char/hw_random/
