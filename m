Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161053AbaKNMzQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 07:55:16 -0500
Received: from mail-yh0-f45.google.com ([209.85.213.45]:62440 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934728AbaKNMzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 07:55:12 -0500
MIME-Version: 1.0
Date: Fri, 14 Nov 2014 18:25:12 +0530
Message-ID: <CAD6G_RREb58La-pC48BHW+9r9oruUXnCrk-RS8LaKSw6y9jgxg@mail.gmail.com>
Subject: read performance is too low compared to write - /dev/sda1
From: Jagan Teki <jagannadh.teki@gmail.com>
To: tj@kernel.org, davem@davemloft.net
Cc: linux-ide@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm doing a performance testing on my bench ARM box.

1. dd test: I have validate the read and write by mounting /dev/sda1
with ext4 filesystem,
    able to get the good performance numbers where read is high
compared to write

2.  robocopy test:
     - mkfs.ext4 /dev/sda1
     - mount /dev/sda1 /media/disk
     - << configured samba >>
     - Mapped the /media/disk on windows
     - login on the mapped driver in windows
     - did a robocopy test, where write got 84MBps and read 14MBps

read performance is too slow when compared to write in robocopy case.
Can anyone help me out, how to debug this further.

thanks!
-- 
Jagan.
