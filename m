Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab3GFKJY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 06:09:24 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:56706 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870Ab3GFKJW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 06:09:22 -0400
MIME-Version: 1.0
From: Hui Zhu <teawater@gmail.com>
Date: Sat, 6 Jul 2013 18:08:42 +0800
Message-ID: <CANFwon3mt2ZT9vpm7R-teYBkH0c+GDWZSq7TpFswbE+7=b6iFw@mail.gmail.com>
Subject: KGTP (Linux debugger and tracer) 20130706 release (bugs fix and doc update)
To: linux-kernel@vger.kernel.org, "gdb@sourceware.org" <gdb@sourceware.org>,
        kgtp <kgtp@freelists.org>
Cc: Marc Khouzam <marc.khouzam@ericsson.com>,
        Thiago Jung Bauermann <thiago.bauermann@gmail.com>,
        Steven <mqyoung@gmail.com>, colyli@gmail.com,
        Christoph Hellwig <hch@infradead.org>,
        Geoff Levand <geoff@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Geunsik Lim <leemgs1@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Tao Ma <taoma.tm@gmail.com>,
        Oliver Yang <yangoliver@gmail.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

KGTP (http://code.google.com/p/kgtp/) is a flexible, lightweight and
realtime Linux debugger and tracer.
To use it, you don't need patch or rebuild the Linux kernel. Just
build KGTP module and insmod it is OK.
I will introduce KGTP in GNU Tools Cauldron 2013
http://gcc.gnu.org/wiki/cauldron2013.

Please go to http://code.google.com/p/kgtp/wiki/HOWTO or
http://code.google.com/p/kgtp/wiki/HOWTO (Chinese) to get more info
about howto use KGTP.

Please goto https://code.google.com/p/kgtp/wiki/HOWTO#Table_of_different_between_GDB_debug_normal_program_and_KGTP
or https://code.google.com/p/kgtp/wiki/HOWTOCN#GDB调试普通程序和KGTP的区别表
(Chinese) get the table of different between GDB debug normal program
and KGTP if you have experience using GDB debug normal program.

Now, KGTP 20130706 release.
You can get the package for it from
http://kgtp.googlecode.com/files/kgtp_20130706.tar.bz2
or
svn co https://kgtp.googlecode.com/svn/tags/20130706

The main change of this release is:
Fix bug with functions return value.
Fix dead lock with dynamic watch tracepoint.
Add $watch_prev_val to show the previous value that watch tracepoint
is watching on.
Update doc add "Get the way that access the variable that has been out
through parse ASM code".
Please goto http://code.google.com/p/kgtp/wiki/UPDATE get more info
about this release.

According to the comments of Christoph, Geoff and Andi.  I make lite
patch for review.  Please goto https://lkml.org/lkml/2012/5/9/90 to
see it.

Thanks,
Hui
