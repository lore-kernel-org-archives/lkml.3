Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab3HPP2E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 11:28:04 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:53623 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab3HPP2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 11:28:00 -0400
From: Matt Porter <matt.porter@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: [PATCH 0/2] g_ffs CDC ACM support
Date: Fri, 16 Aug 2013 11:27:46 -0400
Message-Id: <1376666868-32581-1-git-send-email-matt.porter@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series fixes a build warning from USB Ethernet module parameters
in g_ffs and adds an additional configuration for CDC ACM + FunctionFS.

Matt Porter (2):
  usb: gadget: ffs: fix eth module parameters warning in pure-only
    config
  usb: gadget: ffs: add ACM + FunctionFS configuration

 drivers/usb/gadget/Kconfig |    9 ++++++
 drivers/usb/gadget/g_ffs.c |   74 ++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 81 insertions(+), 2 deletions(-)

-- 
1.7.9.5

