Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770Ab3A3Q3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 11:29:55 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:45457 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab3A3Q3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 11:29:52 -0500
MIME-Version: 1.0
Date: Wed, 30 Jan 2013 11:29:47 -0500
Message-ID: <CAO-9seDOX5wPrjPP0y2cFpqu_Lwo73yyGxfMGjYbBXz7gk24_g@mail.gmail.com>
Subject: Opteron 6276 Corrected ECC errors
From: Michael Madore <michael.madore@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have the following system:

Supermicro H8QGi-F server board (AMD SR5690/SR5670/SP5100 Chipset)
4 X AMD Opteron 6276 processors
32 X 8GB (256GB) DDR3-1600 ECC Registered memory
Debian with kernel 3.2.35-2

We have received the following two hardware errors:

9/10/12

[591006.120039] [Hardware Error]: CPU:58
MC2_STATUS[-|CE|MiscV|-|-|-|-|CECC]: 0x9842c000000c0176
[591006.120048] [Hardware Error]: Combined Unit Error: VB Data/ECC error.
[591006.120052] [Hardware Error]: cache level: L2, tx: DATA, mem-tx: EV

1/21/12

[549004.336097] [Hardware Error]: CPU:40
MC4_STATUS[-|CE|MiscV|-|AddrV|-|-|CECC]: 0x9c3444e0001f010b
[549004.336111] [Hardware Error]:       MC4_ADDR: 0x000000000000e480
[549004.336117] [Hardware Error]: Northbridge Error (node 5): ECC
Error in the Probe Filter directory.
[549004.336125] [Hardware Error]: cache level: L3/GEN, tx: GEN, mem-tx: GEN

If I understand correctly, both of these errors represent single bit
corrected errors in the CPU cache.  On both occasions the system
continued to function normally after the error was reported.

Is receiving two such errors (on different CPUs) over such a time span
cause for concern?  The end user is concerned there is a serious
hardware problem.  I'm reluctant to start replacing CPUs, however,
without seeing a repeated pattern of errors.

Any advice or pointers to more appropriate resources would be greatly
appreciated.  Please CC: me as I am not currently subscribed to the
list.

Thanks,

Mike
