Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab3CKFHR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 01:07:17 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:55925 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491Ab3CKFHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 01:07:15 -0400
MIME-Version: 1.0
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 11 Mar 2013 10:36:53 +0530
Message-ID: <CA+V-a8seGgMO_F+bAV-DS6XSvRQ+7+bgNyenJh-oR6WFzhvW=A@mail.gmail.com>
Subject: [GIT PULL FOR v3.9] DaVinci media driver fixes
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: dlos <davinci-linux-open-source@linux.davincidsp.com>,
        linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

Please pull the following patches for Davinci.
The first patch fixes module build for VPBE driver
and the second patch fixes the module build for VPIF
driver.

The following changes since commit f6161aa153581da4a3867a2d1a7caf4be19b6ec9:

  Linux 3.9-rc2 (2013-03-10 16:54:19 -0700)

are available in the git repository at:
  git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git for_mauro

Lad, Prabhakar (2):
      davinci: vpbe: fix module build
      davinci: vpif: Fix module build for capture and display

 drivers/media/platform/davinci/vpbe_osd.c  |    3 +++
 drivers/media/platform/davinci/vpbe_venc.c |    3 +++
 drivers/media/platform/davinci/vpif.c      |    4 ++++
 3 files changed, 10 insertions(+), 0 deletions(-)
