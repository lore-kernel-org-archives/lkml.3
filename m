Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbaIVSDH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 14:03:07 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:65330 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017AbaIVSDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 14:03:06 -0400
From: Florian Fainelli <f.fainelli@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, computersforpeace@gmail.com,
        thomas.petazzoni@free-electrons.com,
        linux-arm-kernel@lists.infradead.org,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v3 0/2] bus: brcmstb_gisb: misc fixes
Date: Mon, 22 Sep 2014 11:02:44 -0700
Message-Id: <1411408966-15390-1-git-send-email-f.fainelli@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

This patch set contains two small fixes for the Broadcom GISB bus
arbiter code. First patch makes sure we do register a fault code for
ARM platforms, second patch is a fix when the code is used on a PM
capable system.

Florian Fainelli (2):
  bus: brcmstb_gisb: register the fault code hook
  bus: brcmstb_gisb: save and restore GISB timeout

 drivers/bus/brcmstb_gisb.c | 45 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 39 insertions(+), 6 deletions(-)

-- 
1.9.1

