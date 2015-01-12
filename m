Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbbALNcf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 08:32:35 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:54480 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbbALNcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 08:32:32 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Steven Honeyman <stevenhoneyman@gmail.com>,
        Jean Delvare <jdelvare@suse.de>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 0/9] i8k patches
Date: Mon, 12 Jan 2015 14:31:56 +0100
Message-Id: <1421069525-12875-1-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series contains all i8k patches which were already sent to LKML and
are not included in Greg's char-misc-testing branch yet (2015-01-12).

Guenter Roeck (2):
  i8k: Rework error retries
  i8k: Add support for Dell XPS 13

Pali Rohár (7):
  i8k: Add support for temperature sensor labels
  i8k: Register only temperature sensors which have labels
  i8k: Return -ENODATA for invalid temperature
  i8k: Make fan module parameters an unsigned
  i8k: Autodetect fan RPM multiplier
  i8k: Remove DMI config data for Latitude E6440 and E6540
  i8k: Add support for fan labels

 drivers/char/i8k.c |  316 ++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 217 insertions(+), 99 deletions(-)

-- 
1.7.9.5

