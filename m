Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777AbaBQNX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 08:23:29 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:38640 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbaBQNX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 08:23:26 -0500
MIME-Version: 1.0
X-Originating-IP: [42.61.198.132]
Date: Mon, 17 Feb 2014 21:23:25 +0800
Message-ID: <CAMVG2ss9nA4zcOT3c47EwEMrR7Z_gAQU-HTYGjdWcdYzihSnbg@mail.gmail.com>
Subject: USB keyboard occasional key stuck
From: Daniel J Blueman <daniel@quora.org>
To: linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Across 5+ years of kernels, I've been seeing occasional (1-2 times per
day) key-stuck issues where eg a fn+delete combo repeats delete until
I press delete again. I've seen this happen with fn+ctrl+left, leaving
left held and likewise with right.

This has occurred on Apple laptops, external USB keyboards and Dell
laptops, so seems like a linux USB input issue, as I haven't seen
occur on Windows or MacOS on the same hardware.

It seems a good move for me to rebuild and run a kernel with some USB
HID instrumentation to locate this issue over time. Without apriori
knowledge of the linux USB input stack, what is a good initial
approach?

Thanks,
  Daniel
-- 
Daniel J Blueman
