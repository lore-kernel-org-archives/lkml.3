Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297AbaHJFPb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 01:15:31 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:35448 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbaHJFPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 01:15:30 -0400
Date: Sat, 9 Aug 2014 22:16:00 -0700
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, linux-kernel@vger.kernel.org
Subject: [GIT PULL] platform/chrome: Updates for 3.17
Message-ID: <20140810051600.GA15267@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit cd3de83f147601356395b57a8673e9c5ff1e59d1:

  Linux 3.16-rc4 (2014-07-06 12:37:51 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/olof/chrome-platform.git tags/for-linus

for you to fetch changes up to 5502486a2077e4280c618b82e8a77ed35932956f:

  platform/chrome: chromeos_laptop - Add a limit for deferred retries (2014-07-15 18:02:01 -0700)

----------------------------------------------------------------
platform/chrome: Updates for 3.17

Updates to the Chromebook/box platform drivers:

- A bugfix to pstore registration that makes it also work on non-Google
  systems
- Addition of new shipped Chromebooks (later models have more probing
  through ACPI so the need for these updates will be less over time).
- A couple of minor coding style updates

----------------------------------------------------------------
Benson Leung (2):
      platform/chrome: chromeos_laptop - Add HP Chromebook 14
      platform/chrome: chromeos_laptop - Add a limit for deferred retries

Gene Chen (1):
      platform/chrome: chromeos_laptop - Add Toshiba CB35 Touch

Michael Mullin (1):
      platform/chrome: Add support for the acer c720p touchscreen.

Mika Westerberg (1):
      platform/chrome: chromeos_laptop - Add support for Acer C720

Mohammed Habibulla (1):
      platform/chrome: chromeos_laptop - Add Dell Chromebook 11 touch

Olof Johansson (1):
      platform/chrome: pstore: fix dmi table to match all chrome systems

Robin Schroer (1):
      platform/chrome: coding style fixes

 drivers/platform/chrome/chromeos_laptop.c | 140 +++++++++++++++++++++++++++---
 drivers/platform/chrome/chromeos_pstore.c |  14 +--
 2 files changed, 132 insertions(+), 22 deletions(-)
