Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121Ab3FABf7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 21:35:59 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:34738 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab3FABfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 21:35:52 -0400
From: Julius Werner <jwerner@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dongjin Kim <tobetter@gmail.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Simon Glass <sjg@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olofj@chromium.org>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Julius Werner <jwerner@chromium.org>
Subject: [PATCH 0/3] usb: misc: usb3503: Fix up usb3503 driver
Date: Fri, 31 May 2013 18:34:49 -0700
Message-Id: <1370050492-6046-1-git-send-email-jwerner@chromium.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set contains a few minor changes to the recently added SMSC
USB3503 driver. It addresses issues that seem to be either left-over
stopgaps from an early development stage or board-specific hacks,
changing them to defaults that should be most sane and useable for all
platforms that contain this chip.

Julius Werner (3):
  usb: misc: usb3503: Fix up whitespace
  usb: misc: usb3503: Remove hardcoded disabling of ports 2 and 3
  usb: misc: usb3503: Remove 100ms sleep on reset, conform to data
    sheet

 drivers/usb/misc/usb3503.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

-- 
1.7.12.4

