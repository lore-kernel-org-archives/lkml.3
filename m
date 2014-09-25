Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbaIYXA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 19:00:29 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:62722 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbaIYXA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 19:00:27 -0400
MIME-Version: 1.0
Date: Thu, 25 Sep 2014 16:00:25 -0700
Message-ID: <CACHGV4L+-NDoLUmfiqQ2YWOm51WnjGVU3k-rw74DRtouJocjNg@mail.gmail.com>
Subject: kernel BUG at /src/linux-bcache/kernel/smpboot.c:134!
From: Slava Pestov <sp@datera.io>
To: tglx@linutronix.de, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas and everyone else,

I saw in a thread last year you fixed a similar (or same?) bug as the
subject[1]. However I can still reproduce this issue using kernels
that have your patch in them. I filed a bug with qemu[2] containing a
repro (just boot a VM with multiple CPUs and init=/sbin/reboot and let
it cycle) but after finding the above thread I'm not convinced its a
qemu issue anymore.

Any ideas?

Slava

[1] https://lkml.org/lkml/2013/4/8/306
[2] https://bugs.launchpad.net/qemu/+bug/1359383
