Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790AbaAFT7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 14:59:37 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:52482 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755383AbaAFT7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 14:59:35 -0500
MIME-Version: 1.0
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Tue, 7 Jan 2014 01:28:55 +0530
Message-ID: <CALkWK0=--MxTMTmdYzKotUfbctgc09rJ6R=9WB2XHTP-jnbz-A@mail.gmail.com>
Subject: apple_gmux: switcheroo not working on a 2013 MBP
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andreas Heider <andreas@meetr.de>,
        Seth Forshee <seth.forshee@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I loaded the apple_gmux driver and tried to:

  $ echo IGD >/sys/kernel/debug/vgaswitcheroo/switch

dmesg responds with:

  vga_switcheroo: client 1 refused switch

It's possible that the gmux interface has changed since the driver was
originally written. How do I dig deeper into the issue and help fix
the driver?

Thanks.

Ram
