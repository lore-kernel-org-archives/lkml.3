Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750996AbaAKX4R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 18:56:17 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:59960 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaAKX4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 18:56:14 -0500
Date: Sun, 12 Jan 2014 00:55:12 +0100
From: Tim Jester-Pfadt <t.jp@gmx.de>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, standby24x7@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] Staging: rtl8188eu: checkpatch.pl error cleanups
Message-ID: <cover.1389483651.git.t.jp@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fixes all occurrences of the "space required after ','" "space
required around '='" aswell as "foo * bar" related checkpatch.pl errors in
rtl8188eu.

The patchset does not fix the remaining 80 character limit warnings, sinc this
might require more substantial code modification.

v2: Patched against the staging-next branch as requested by Greg KH.

Tim Jester-Pfadt (2):
  Staging: rtl8188eu: Fixed required spaces after ',' and around '=' and
    '=='
  Staging: rtl8188eu: Fixed "foo * bar" related coding style issues

 drivers/staging/rtl8188eu/include/Hal8188EPwrSeq.h |  2 +-
 drivers/staging/rtl8188eu/include/odm.h            |  2 +-
 drivers/staging/rtl8188eu/include/odm_debug.h      |  2 +-
 drivers/staging/rtl8188eu/include/odm_interface.h  |  2 +-
 drivers/staging/rtl8188eu/include/rtl8188e_hal.h   |  4 ++--
 drivers/staging/rtl8188eu/include/rtl8188e_recv.h  |  6 +++---
 drivers/staging/rtl8188eu/include/rtw_eeprom.h     |  2 +-
 drivers/staging/rtl8188eu/include/rtw_efuse.h      |  2 +-
 drivers/staging/rtl8188eu/include/rtw_ioctl_set.h  |  4 ++--
 drivers/staging/rtl8188eu/include/rtw_iol.h        |  8 ++++----
 drivers/staging/rtl8188eu/include/rtw_led.h        |  6 +++---
 drivers/staging/rtl8188eu/include/rtw_mlme.h       |  8 ++++----
 drivers/staging/rtl8188eu/include/rtw_mlme_ext.h   | 12 ++++++------
 drivers/staging/rtl8188eu/include/rtw_mp.h         | 10 +++++-----
 drivers/staging/rtl8188eu/include/rtw_mp_ioctl.h   |  2 +-
 drivers/staging/rtl8188eu/include/rtw_security.h   |  2 +-
 drivers/staging/rtl8188eu/include/wifi.h           |  2 +-
 17 files changed, 38 insertions(+), 38 deletions(-)

-- 
1.8.5.2

