Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbaLUTzZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 14:55:25 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:61431 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581AbaLUTzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 14:55:24 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 00/10] i8k patches
Date: Sun, 21 Dec 2014 20:54:33 +0100
Message-Id: <1419191683-31435-1-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series contains all i8k patches which were not merged to char-misc tree yet.

Guenter Roeck (3):
  MAINTAINERS: Fix up entry for Dell laptop SMM driver
  i8k: Rework error retries
  i8k: Add support for Dell XPS 13

Pali Rohár (7):
  i8k: Add support for temperature sensor labels
  i8k: Register only temperature sensors which have labels
  i8k: Return -ENODATA for invalid temperature
  i8k: Make fan module parameters an unsigned
  i8k: Autodetect maximal fan speed and fan RPM multiplier
  i8k: Remove DMI config data for Latitude E6x40
  i8k: Add support for fan labels

 MAINTAINERS        |    1 +
 drivers/char/i8k.c |  341 +++++++++++++++++++++++++++++++++++++---------------
 2 files changed, 244 insertions(+), 98 deletions(-)

-- 
1.7.9.5

