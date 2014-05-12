Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137AbaELBsJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:48:09 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:44050 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbaELBsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:48:06 -0400
MIME-Version: 1.0
From: Hui Zhu <teawater@gmail.com>
Date: Mon, 12 May 2014 09:47:25 +0800
Message-ID: <CANFwon2DxQLpYS=0ja-a_xHx9RJxhUXhz+827Tv3DYsT6pfebQ@mail.gmail.com>
Subject: KGTP (dynamic tracer for Linux kernel and applications) 20140510
 release (add quick start script kgtp.py)
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gdb@sourceware.org" <gdb@sourceware.org>, kgtp <kgtp@freelists.org>
Cc: Marc Khouzam <marc.khouzam@ericsson.com>,
        Thiago Jung Bauermann <thiago.bauermann@gmail.com>,
        Steven <mqyoung@gmail.com>, Coly Li <colyli@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        Geoff Levand <geoff@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Geunsik Lim <leemgs1@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Tao Ma <taoma.tm@gmail.com>,
        Oliver Yang <yangoliver@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KGTP (http://teawater.github.io/kgtp/) is a comprehensive dynamic tracer for
analysing Linux kernel and application (including Android) problems on
production systems in real time.

I think people use KGTP first trouble is to configure complex.
So the main change of this version is add a script kgtp.py that will
auto setup and start KGTP and GDB in current machine.
Then to use KGTP:
wget https://raw.githubusercontent.com/teawater/kgtp/master/kgtp.py
sudo python kgtp.py

Please goto https://github.com/teawater/kgtp/blob/release/UPDATE
get more info about this release.

According to the comments of Christoph, Geoff and Andi.  I make KGTP
function lite patch for Linux kernel upstream.  Please goto
http://lkml.org/lkml/2013/11/21/7 to got it.

Thanks,
Hui
