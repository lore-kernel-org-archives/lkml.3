Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609Ab3GKK2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 06:28:21 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:58516 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab3GKK2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 06:28:20 -0400
MIME-Version: 1.0
Date: Thu, 11 Jul 2013 12:28:20 +0200
Message-ID: <CAF2Nc0xVKS+aL0CXdDFQHSapvRxM35KZkjeKeigQ7X43+2NVBA@mail.gmail.com>
Subject: Error 2: No rule to make target kernel/timeconst.pl
From: Konrad Vrba <konrad.vrba@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I have following error while compiling new stable kernel 3.10:

  CC      kernel/fork.o
  CC      kernel/exec_domain.o
  CC      kernel/panic.o
  CC      kernel/printk.o
  CC      kernel/cpu.o
  CC      kernel/exit.o
  CC      kernel/itimer.o
make[1]: *** No rule to make target `kernel/timeconst.pl', needed by
`kernel/timeconst.h'.  Stop.
make: *** [kernel] Error 2

Could somebody please advise how to fix this ?
