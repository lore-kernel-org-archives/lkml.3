Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757849AbaISTur (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 15:50:47 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:38954 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757686AbaISTuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 15:50:46 -0400
From: Florian Fainelli <f.fainelli@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, computersforpeace@gmail.com,
        linux-arm-kernel@lists.infradead.org,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v2 0/2] bus: brcmstb_gisb: misc fixes
Date: Fri, 19 Sep 2014 12:50:28 -0700
Message-Id: <1411156230-24024-1-git-send-email-f.fainelli@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Arnd,

Hi Arnd,

This patch set contains two small fixes for the Broadcom GISB bus
arbiter code. First patch makes sure we do register a fault code for
ARM platforms, second patch is a fix when the code is used on a PM
capable system.

Changes in v2:
- move the hunk that adds 'saved_timeout' where it belongs, in patch 2

Florian Fainelli (2):
  bus: brcmstb_gisb: register the fault code hook
  bus: brcmstb_gisb: save and restore GISB timeout

 drivers/bus/brcmstb_gisb.c | 40 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

-- 
1.9.1

