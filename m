Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab3JMPAs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 11:00:48 -0400
Received: from mail-lb0-f196.google.com ([209.85.217.196]:34498 "EHLO
	mail-lb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112Ab3JMPAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 11:00:47 -0400
MIME-Version: 1.0
Date: Sun, 13 Oct 2013 23:00:45 +0800
Message-ID: <CAAcT17XjtPnJ9CvyxMOc7dU7u_oyUpyUua9i2sRTC-nYGQNsgA@mail.gmail.com>
Subject: While I use qemu and gdb to debug a kernel, it stucks in "[0]kdb>"
 and can't enter anything
From: =?GB2312?B?u8bo9w==?= <hzbhlztok@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gdb show that the statement that is excuted is
93			ret = nb->notifier_call(nb, val, v);
and qemu just says "[0]kdb>" but i can't type a word in it.

When I run :

qemu-system-x86_64  -kernel /home/mm/kdb-work/bzImage  -append
"root=/dev/sda" -boot c -hda /home/mm/kdb-work/busybox.img -k en-us

The qemu starts but it seems that there is a problem because it says
"Kernel panic -not syncing:No init found"

I want to know if this make the problem?
Does any body can help me? Thanks a lot
