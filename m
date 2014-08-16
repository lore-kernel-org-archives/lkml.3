Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818AbaHPWBQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 18:01:16 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:34261 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbaHPWBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 18:01:15 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sat, 16 Aug 2014 23:00:54 +0100
X-Google-Sender-Auth: nNywZbLd-zxoybKjEwsQDE9o5OA
Message-ID: <CACxGe6s1eW5aZ7b39152xBodWz6uXpmmaK2RZS-MrKVed0KKNg@mail.gmail.com>
Subject: [GIT PULL] Additional devicetree changes for v3.17
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following tree with some bug fixes for devicetree.

g.

The following changes since commit c9d26423e56ce1ab4d786f92aebecf859d419293:

  Merge tag 'pm+acpi-3.17-rc1-2' of
git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
(2014-08-14 18:13:46 -0600)

are available in the git repository at:


  git://git.secretlab.ca/git/linux tags/devicetree-for-linus

for you to fetch changes up to a9ecdc0fdc54aa499604dbd43132988effcac9b4:

  of/irq: Fix lookup to use 'interrupts-extended' property first
(2014-08-16 09:03:58 +0100)

----------------------------------------------------------------
Additional devicetree changes for v3.17

Three more commits needed for v3.17: A bug fix for reserved regions
based at address zero, a clarification on how to interpret existence of
both interrupts and interrupts-extended properties, and a fix to allow
device tree testcases to run on any platform.

----------------------------------------------------------------
Al Cooper (1):
      of: Allow mem_reserve of memory with a base address of zero

Florian Fainelli (1):
      of/irq: Fix lookup to use 'interrupts-extended' property first

Gaurav Minocha (1):
      Enabling OF selftest to run without machine's devicetree

 .../bindings/interrupt-controller/interrupts.txt   | 12 ++++---
 drivers/of/fdt.c                                   |  2 +-
 drivers/of/irq.c                                   | 17 ++++-----
 drivers/of/selftest.c                              | 40 +++++++++++++++++-----
 4 files changed, 48 insertions(+), 23 deletions(-)
