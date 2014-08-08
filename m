Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbaHHEwR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 00:52:17 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:38339 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbaHHEwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 00:52:15 -0400
MIME-Version: 1.0
Date: Fri, 8 Aug 2014 06:52:14 +0200
Message-ID: <CACZDEvG3vo4KyUxtpdUzinVVWj355jt3ANV3YNC2VFmGQCzcYg@mail.gmail.com>
Subject: kernel in spinlock or deschduled : packet loss during 1 Mpps transfer
From: anshul makkar <anshulmakkar@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am transferring 1 Million packets from send process to receive
process. Both are running in separate cores. I am using Using DMA
transfer from usermode to the ethernet card.

After transfer I can see 700 - 800 packets loss per transaction.

I doubt that during the transfer kernel may be entering some spinlocks
or descheduling the receiver processor for long enough.

Please can you share how can I debug this case. Please share as to
what approach I can take to detect that. The time involved in the
tranfer is very less around 1 Million packets per second and in that
second packet loss is happening.

Thanks
Anshul Makkar
www.justkernel.com
http://www.linkedin.com/groups/Just-Kernel-3033180
