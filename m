Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198Ab3ETPJ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 11:09:59 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:51761 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951Ab3ETPJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 11:09:56 -0400
MIME-Version: 1.0
Date: Mon, 20 May 2013 18:09:55 +0300
Message-ID: <CAHp75Vdf6gFZChS47=grUygHBDWcoOWDYPzw+Zj5bdVCWj85Jw@mail.gmail.com>
Subject: The dd72be99 breaks some of Intel Medfield based devices
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Bin Gao <bin.gao@linux.intel.com>, Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I don't know what you trying to fix, but your patch dd72be99
"x86/pci/mrst: Use configuration mechanism 1 for 00:00.0, 00:02.0,
00:03.0" breaks Intel Medfield devices.

After it was applied (sorry, was on vacation, didn't noticed sooner)
lspci shows only 18 out of 34 devices. That means the so called fake
PCI devices are gone.

This is a bad approach and patch should be reverted. Bin, please,
explain what you are trying to fix and on what device. We will find
better solution.

P.S. Keep me in Cc list.

--
With Best Regards,
Andy Shevchenko
