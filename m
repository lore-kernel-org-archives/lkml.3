Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831Ab3DQKFS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 06:05:18 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:35398 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754360Ab3DQKFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 06:05:16 -0400
MIME-Version: 1.0
Date: Wed, 17 Apr 2013 15:35:15 +0530
Message-ID: <CAGZFCEHb2Cb_LGXtcYmhDvd0d0zjdb3-5D7-6EBjXmHLJESYoA@mail.gmail.com>
Subject: scheduler context
From: ratheesh kannoth <ratheesh.ksz@gmail.com>
To: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I would like to understand on linux scheduler context. I have read a
lot in websites and i could find
contradictory statement. There are so many mailing list also ,but with
less info. I would really appreciate
if anybody could spend some time answering my question.

1. Which context scheduler run ? ( process context or interrupt context ).
2. scheduler is the guy  who picks up the next candidate to run.  if
it gets interrupted by hardirq, what will happen ?
3. if scheduler run in process context , how bottom half are scheduled ?
4. In smp, schedule() function may be called  simultaneously. How it
is handled ?
5. When a bottom half is interrupted  by hard irq, how softirq kernel
thread saves the state and restart it later ? ...what i mean is , an
   hardirq came and its isr executed. bottom half enabled and bottom
half gets scheduled . Before bottom half is completed , next irq
   came and it enables bottom half , and the new bottom half is
scheduled ....So here , what will happen to old bottom half , will it
again
   run later ?


Thanks,
Ratheesh
