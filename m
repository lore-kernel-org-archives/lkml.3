Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbaJQNMj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 09:12:39 -0400
Received: from mail.logicbricks.com ([89.201.165.134]:17283 "EHLO
	mail.logicbricks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbaJQNMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 09:12:38 -0400
X-Greylist: delayed 319 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Oct 2014 09:12:38 EDT
From: Davor Joja <davorjoja@logicbricks.com>
To: <linux-kernel@vger.kernel.org>
Subject: Xylon framebuffer driver
Date: Fri, 17 Oct 2014 15:06:51 +0200
Message-ID: <1413551221-15187-1-git-send-email-davorjoja@logicbricks.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.0.95]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The patches are based on:
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
at commit 0429fbc0bdc297d64188483ba029a23773ae07b0

The patches implement Xylon framebuffer driver for logiCVC IP core device.
logiCVC is Configurable Video Controller developed and optimized for Xilinx
FPGA Spartan 6 and Series 7 devices.
Driver compiles without errors or warnings on 3.17, andr has been tested
with Xilinx Linux ARM kernel 3.15 on Zynq SoC, with standard fb console on
embedded device LCDs.

Kind regards,
Davor

