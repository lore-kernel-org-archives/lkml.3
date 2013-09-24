Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750854Ab3IXHTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 03:19:46 -0400
Received: from 87-127-191-49.static.enta.net ([87.127.191.49]:55899 "EHLO
	mail.linicks.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab3IXHTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 03:19:45 -0400
Date: Tue, 24 Sep 2013 08:19:43 +0100
From: Nick Warne <nick@linicks.net>
To: linux-kernel@vger.kernel.org
Subject: Re: Linux 3.12-rc2
Message-ID: <20130924071943.GA2112@sauron>
References: <20130920195939.GA2353@sauron>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130920195939.GA2353@sauron>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I have couple of  build warnings.  Not sure if this happened with rc1, as I only have moved across to the rc trees:

gcc (GCC) 4.2.4 on amd64 - no modules build:


1)
...
  GEN     lib/crc32table.h
  CC      lib/crc32.o
lib/crc32.c: In function ‘crc32_be’:
lib/crc32.c:263: warning: passing argument 4 of ‘crc32_be_generic’ from incompatible pointer type
lib/crc32.c: In function ‘__crc32c_le’:
lib/crc32.c:199: warning: passing argument 4 of ‘crc32_le_generic’ from incompatible pointer type
lib/crc32.c: In function ‘crc32_le’:
lib/crc32.c:194: warning: passing argument 4 of ‘crc32_le_generic’ from incompatible pointer type
  CC      lib/fonts/fonts.o
...

2)
  CC      lib/radix-tree.o
lib/radix-tree.c: In function ‘radix_tree_next_chunk’:
lib/radix-tree.c:805: warning: comparison is always false due to limited range of data type
  CC      lib/ratelimit.o
...


Nick
-- 
http://linicks.net/
