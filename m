Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546Ab3HTWHK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 18:07:10 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:38790 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751168Ab3HTWHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 18:07:09 -0400
Message-ID: <1377036428.2016.85.camel@joe-AO722>
Subject: Re: Why are BSD-licensed LZ4 symbols GPL exported?
From: Joe Perches <joe@perches.com>
To: Rob Landley <rob@landley.net>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Richard Yao <ryao@gentoo.org>,
        chanho.min@lge.com,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Yann Collet o <yann.collet.73@gmail.com>
Date: Tue, 20 Aug 2013 15:07:08 -0700
In-Reply-To: <1377035193.2016.81.camel@joe-AO722>
References: <520D8C4C.7000704@gentoo.org>
	 <20130820171148.GA17832@srcf.ucam.org> <1377020294.2016.51.camel@joe-AO722>
	 <1377034669.2737.83@driftwood> <1377035193.2016.81.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-20 at 14:46 -0700, Joe Perches wrote:
> Because your

Sorry, not your's but Matthew's.

I do think the MODULE_LICENSE should be "Dual BSD/GPL"
instead of merely "GPL" if for no other reason than
politeness to the original developer and the
license at the top of the files.

 * LZ4 - Fast LZ compression algorithm
 * Copyright (C) 2011-2012, Yann Collet.
 * BSD 2-Clause License (http://www.opensource.org/licenses/bsd-license.php)

---
 lib/lz4/lz4_compress.c   | 2 +-
 lib/lz4/lz4_decompress.c | 2 +-
 lib/lz4/lz4hc_compress.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/lz4/lz4_compress.c b/lib/lz4/lz4_compress.c
index fd94058..a4001ee 100644
--- a/lib/lz4/lz4_compress.c
+++ b/lib/lz4/lz4_compress.c
@@ -439,5 +439,5 @@ exit:
 }
 EXPORT_SYMBOL_GPL(lz4_compress);
 
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("Dual BSD/GPL");
 MODULE_DESCRIPTION("LZ4 compressor");
diff --git a/lib/lz4/lz4_decompress.c b/lib/lz4/lz4_decompress.c
index d3414ea..c45e685 100644
--- a/lib/lz4/lz4_decompress.c
+++ b/lib/lz4/lz4_decompress.c
@@ -321,6 +321,6 @@ exit_0:
 #ifndef STATIC
 EXPORT_SYMBOL_GPL(lz4_decompress_unknownoutputsize);
 
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("Dual BSD/GPL");
 MODULE_DESCRIPTION("LZ4 Decompressor");
 #endif
diff --git a/lib/lz4/lz4hc_compress.c b/lib/lz4/lz4hc_compress.c
index eb1a74f..59f26e6 100644
--- a/lib/lz4/lz4hc_compress.c
+++ b/lib/lz4/lz4hc_compress.c
@@ -535,5 +535,5 @@ exit:
 }
 EXPORT_SYMBOL_GPL(lz4hc_compress);
 
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("Dual BSD/GPL");
 MODULE_DESCRIPTION("LZ4HC compressor");


