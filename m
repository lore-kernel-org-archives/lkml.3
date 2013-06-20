Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab3FTHm2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 03:42:28 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:63977 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273Ab3FTHm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 03:42:27 -0400
Message-ID: <1371714142.25488.1.camel@phoenix>
Subject: [linux-next 20130619] make at91x40_defconfig build error
From: Axel Lin <axel.lin@ingics.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 20 Jun 2013 15:42:22 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Test on linux-next 20130619.
I Got below build error by "make at91x40_defconfig; make"

fs/built-in.o: In function `copy_strings':
super.c:(.text+0x6398): undefined reference to `flush_kernel_dcache_page'
super.c:(.text+0x6420): undefined reference to `flush_kernel_dcache_page'
lib/built-in.o: In function `sg_miter_stop':
strnlen_user.c:(.text+0x3394): undefined reference to `flush_kernel_dcache_page'
make: *** [vmlinux] Error 1


