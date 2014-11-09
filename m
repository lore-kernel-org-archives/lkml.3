Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365AbaKIBWa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 20:22:30 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:39214 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbaKIBW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 20:22:27 -0500
From: Konrad Zapalowicz <bergo.torino@gmail.com>
To: cascardo@linux.vnet.ibm.com
Cc: gregkh@linuxfoundation.org, jslaby@suse.cz, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Konrad Zapalowicz <bergo.torino@gmail.com>
Subject: [PATCH 0/5] serial: jsm: Provide better code quality
Date: Sun,  9 Nov 2014 02:22:15 +0100
Message-Id: <1415496140-14997-1-git-send-email-bergo.torino@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches fixes a few minor issues in the jsm driver.
The patches do not only address the coding style issues however none
of them changes the logic.

These patches are against the current tty-next.

Konrad Zapalowicz (5):
  serial: jsm: Remove unnecessary parameter from clear_break()
  serial: jsm: Remove unnecessary if statement
  serial: jsm: Fix the alignment of the switch satement
  serial: jsm: Replace magic value with the proper define
  serial: jsm: Fix unnecessary space before function ptr arguments

 drivers/tty/serial/jsm/jsm.h     | 30 +++++++++++++++---------------
 drivers/tty/serial/jsm/jsm_cls.c |  5 +----
 drivers/tty/serial/jsm/jsm_neo.c | 31 ++++++++++++++-----------------
 drivers/tty/serial/jsm/jsm_tty.c |  2 +-
 4 files changed, 31 insertions(+), 37 deletions(-)

-- 
1.9.1

