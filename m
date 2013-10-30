Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab3J3GNH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 02:13:07 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:54932 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab3J3GNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 02:13:05 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [RFC PATCH 0/2] DT match helpers for initcalls and platform devices
Date: Wed, 30 Oct 2013 01:12:49 -0500
Message-Id: <1383113571-13029-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

This series adds a couple of boilerplate helpers to match with DT for
initcalls and platform device creation and probe. The goal here is to 
remove more platform code out of arch/arm and eventually the machine
descriptors.

Rob

Rob Herring (2):
  driver core: introduce module_platform_driver_match_and_probe
  of: add initcall with match boilerplate helpers

 include/linux/of.h              | 12 ++++++++++++
 include/linux/platform_device.h | 23 +++++++++++++++++++++++
 2 files changed, 35 insertions(+)

-- 
1.8.1.2

