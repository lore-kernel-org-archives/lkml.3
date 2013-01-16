Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757765Ab3APWHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 17:07:46 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:60427 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024Ab3APWHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 17:07:45 -0500
MIME-Version: 1.0
Date: Wed, 16 Jan 2013 15:07:44 -0700
Message-ID: <CAKocOOMytcbVbcgWPXA8s6+Mm6jSkwB1XqViSN12s53Xj6Bk0Q@mail.gmail.com>
Subject: Linux 3.8.rc3 ATI radeon driver broken
From: Shuah Khan <shuahkhan@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am seeing dmesg filling up with the DMAR faults on

01:00.0 VGA compatible controller: Advanced Micro Devices [AMD] nee ATI RV620 [M
obility Radeon HD 3400 Series] (prog-if 00 [VGA controller])

 [   21.436041] DMAR:[fault reason 06] PTE Read access is not set
[   21.436071] dmar: DRHD: handling fault status reg 3
[   21.436075] dmar: DMAR:[DMA Read] Request device [01:00.0] fault
addr 80004000

This is new to rc-3 and also reboot and shutdown both hang.

I am going to start bisecting to isolate the problem and let you know
what I find.

-- Shuah
