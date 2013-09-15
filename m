Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab3IOH70 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 03:59:26 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:45573 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985Ab3IOH7Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 03:59:25 -0400
MIME-Version: 1.0
From: Hui Zhu <teawater@gmail.com>
Date: Sun, 15 Sep 2013 15:58:44 +0800
Message-ID: <CANFwon1yAeqsDCq7rs=ak3pEUD=sMd81t3C45yTZF+TPLmGOBw@mail.gmail.com>
Subject: KGTP (Linux debugger and tracer) 20130915 release (bugs fix and pdf doc)
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gdb@sourceware.org" <gdb@sourceware.org>, kgtp <kgtp@freelists.org>
Cc: Marc Khouzam <marc.khouzam@ericsson.com>,
        Thiago Jung Bauermann <thiago.bauermann@gmail.com>,
        Steven <mqyoung@gmail.com>, Coly Li <colyli@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        Geoff Levand <geoff@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Geunsik Lim <leemgs1@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Tao Ma <taoma.tm@gmail.com>,
        Oliver Yang <yangoliver@gmail.com>, Brad_Dixon@mentor.com
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
This is the video that I introduce KGTP in GNU Tools Cauldron 2013
http://www.youtube.com/watch?v=7nfGAbNsEZY or
http://www.tudou.com/programs/view/fPu_koiKo38/ .

Please go to http://code.google.com/p/kgtp/wiki/HOWTO
https://raw.github.com/teawater/kgtp/master/kgtp.pdf or
http://code.google.com/p/kgtp/wiki/HOWTO
https://raw.github.com/teawater/kgtp/master/kgtpcn.pdf (Chinese) to
get more info about howto use KGTP.

Please goto https://code.google.com/p/kgtp/wiki/HOWTO#Table_of_different_between_GDB_debug_normal_program_and_KGTP
or https://code.google.com/p/kgtp/wiki/HOWTOCN#GDB调试普通程序和KGTP的区别表
(Chinese) get the table of different between GDB debug normal program
and KGTP if you have experience using GDB debug normal program.

Now, KGTP 20130915 release.
You can get the package:
Get through https:
https://github.com/teawater/kgtp/archive/20130915.tar.gz
Get through git:
git clone https://github.com/teawater/kgtp.git
git checkout 20130915 -b 20130915

The main change of this release is:
Fixed bugs around x86_32.  And They also reminded me to do this test
on x86_32 before release. (I just do x86_64 in before.) Thanks help
from Brad Dixon.
Fixed bugs around while-stepping.
Added pdf format docs.
Moved to github.

Now, I am working on insert tracepoint to user space program that base
on Uprobes.  The most of code work was done.  Please goto
https://github.com/teawater/kgtp/tree/uprobes-dev try it if you are
interesting with this function.

Thanks,
Hui
