Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbaJCJnh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 05:43:37 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:65108 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbaJCJnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 05:43:35 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Yunkang Tang <yunkang.tang@cn.alps.com>,
        Tommy Will <tommywill2011@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 0/3] input: alps: Fixes for ALPS driver
Date: Fri,  3 Oct 2014 11:43:09 +0200
Message-Id: <1412329392-5580-1-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series trying to fix problems with ALPS dualpoint touchpad on
Dell Latitude laptops which are probably caused by bugs in Dell BIOS.

Reported bugs:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1258837
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1320022
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1272624

Pali Rohár (3):
  input: alps: Reset mouse before identifying it
  input: alps: For protocol V3, do not process data when last packet's
    bit7 is set
  input: alps: Reset mouse and ALPS driver immediately after first
    invalid packet

 drivers/input/mouse/alps.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

-- 
1.7.9.5

