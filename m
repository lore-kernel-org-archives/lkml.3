Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbaLIUHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 15:07:32 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:37053 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbaLIUHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 15:07:31 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jean Delvare <jdelvare@suse.de>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 0/3] i8k: Rework fan_mult and fan_max code
Date: Tue,  9 Dec 2014 21:06:58 +0100
Message-Id: <1418155621-21644-1-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds autodetection of fan_mult and fan_max.

Pali Rohár (3):
  i8k: cosmetic: distinguish between fan speed and fan rpm
  i8k: Autodetect maximal fan speed and fan RPM multiplier
  i8k: Remove laptop specific config data (fan_mult, fan_max) from
    driver

 drivers/char/i8k.c       |  258 ++++++++++++++++++++++------------------------
 include/uapi/linux/i8k.h |    4 +-
 2 files changed, 129 insertions(+), 133 deletions(-)

-- 
1.7.9.5

