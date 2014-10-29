Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761AbaJ2IQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 04:16:09 -0400
Received: from atl4mhob01.myregisteredsite.com ([209.17.115.39]:58352 "EHLO
	atl4mhob01.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753555AbaJ2IQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 04:16:07 -0400
X-TCPREMOTEIP: 88.159.208.100
X-Authenticated-UID: mike@milosoftware.com
From: Mike Looijmans <mike.looijmans@topic.nl>
To: lgirdwood@gmail.com, broonie@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Add ltc3562 voltage regulator driver
Date: Wed, 29 Oct 2014 09:15:59 +0100
Message-Id: <1414570560-10320-1-git-send-email-mike.looijmans@topic.nl>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the LTC3562 I2C controlled voltage regulator to
the kernel. The driver was tested and developed on a Topic Miami
board where this chip supplies the IO voltages for the FPGA pins.

