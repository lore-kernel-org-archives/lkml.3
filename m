Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932513Ab3LDN5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 08:57:38 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:57741 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932493Ab3LDN5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 08:57:37 -0500
MIME-Version: 1.0
Date: Wed, 4 Dec 2013 14:57:36 +0100
Message-ID: <CACRpkdZGzz8Diijw_A2dRoX2qzktrJLDJdUiFzA2xsJY3vncfA@mail.gmail.com>
Subject: [GIT PULL] GPIO fixes for the v3.13 series, take two
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Liu Gang <Gang.Liu@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here is a few more GPIO patches, we're a bit noisy for being the
GPIO subsystem, mostly due to the new descriptor API, but all
is getting into shape.

Please pull it in!

Yours,
Linus Walleij

The following changes since commit dc1ccc48159d63eca5089e507c82c7d22ef60839:

  Linux 3.13-rc2 (2013-11-29 12:57:14 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio.git
tags/gpio-v3.13-3

for you to fetch changes up to 351cfe0fe810588bb1cc75fb4f1c1d1d01914b82:

  gpiolib: change a warning to debug message when failing to get gpio
(2013-12-03 13:10:48 +0100)

----------------------------------------------------------------
GPIO fixes for the v3.13 series:

- Fix compile warnings.

- Fix overly talkative diagnostic messages from usual use
  cases wrt GPIO descriptors.

- Add a documentation 00-INDEX

- Use platform GPIOs as fallback when ACPI or device tree is
  used as the primary means to get GPIO lines.

- A bug fix for the MPC8572/MPC8536 fixing erroneous input data.

----------------------------------------------------------------
Alexandre Courbot (4):
      gpiolib: add missing declarations
      gpiolib: fix lookup of platform-mapped GPIOs
      Documentation: gpiolib: add 00-INDEX file
      gpiolib: use platform GPIO mappings as fallback

Heikki Krogerus (1):
      gpiolib: change a warning to debug message when failing to get gpio

Liu Gang (1):
      powerpc/gpio: Fix the wrong GPIO input data on MPC8572/MPC8536

 Documentation/gpio/00-INDEX | 14 ++++++++++++++
 drivers/gpio/gpio-mpc8xxx.c |  8 ++++++--
 drivers/gpio/gpiolib.c      | 20 +++++++++++++++-----
 include/linux/gpio/driver.h |  3 +++
 4 files changed, 38 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/gpio/00-INDEX
