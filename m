Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093Ab3BRLIJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 06:08:09 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:62553 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab3BRLIH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 06:08:07 -0500
MIME-Version: 1.0
From: Hui Zhu <teawater@gmail.com>
Date: Mon, 18 Feb 2013 19:07:25 +0800
Message-ID: <CANFwon1h8FxV3Xy4agY6=AR61U6K5FExXRn5DMetoWzPpdPhYA@mail.gmail.com>
Subject: KGTP (Linux debugger and tracer) 20130218 release (add watch
 tracepoint control hardware breakpoints to record memory and bug fix)
To: linux-kernel@vger.kernel.org, "gdb@sourceware.org" <gdb@sourceware.org>,
        kgtp <kgtp@freelists.org>
Cc: Marc Khouzam <marc.khouzam@ericsson.com>,
        Thiago Jung Bauermann <thiago.bauermann@gmail.com>,
        Steven <mqyoung@gmail.com>, colyli@gmail.com,
        Christoph Hellwig <hch@infradead.org>,
        Geoff Levand <geoff@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Geunsik Lim <leemgs1@gmail.com>,
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

Please go to http://code.google.com/p/kgtp/wiki/HOWTO or
http://code.google.com/p/kgtp/wiki/HOWTO (Chinese) to get more info
about howto use KGTP.

Now, KGTP 20130218 release.
You can get the package for it from
http://kgtp.googlecode.com/files/kgtp_20130218.tar.bz2
or
svn co https://kgtp.googlecode.com/svn/tags/20130218

The main change of this release is add watch tracepoint control
hardware breakpoints to record memory.
Please goto http://code.google.com/p/kgtp/wiki/HOWTO#Howto_use_watch_tracepoint_control_hardware_breakpoints_to_recor
or http://code.google.com/p/kgtp/wiki/HOWTOCN#如何用watch_tracepoint控制硬件断点记录内存访问
(Chinese version) get more info about watch tracepoint.

Another one is fix memory leak of output the value directly function.
Please goto http://code.google.com/p/kgtp/wiki/UPDATE get more info
about this release.

According to the comments of Christoph, Geoff and Andi.  I make lite
patch for review.  Please goto https://lkml.org/lkml/2012/5/9/90 to
see it.

Thanks,
Hui
