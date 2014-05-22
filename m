Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbaEWMvQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 08:51:16 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:62963 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbaEWMvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 08:51:11 -0400
From: Grant Likely <grant.likely@linaro.org>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] of: Clean up naming of platform devices
Date: Fri, 23 May 2014 08:36:07 +0900
Message-Id: <1400801769-4506-1-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series makes of_device_make_bus_id() more reliable in choosing a
unique name and clears out some historical cruft. I've rebased it onto
Rob's for-next tree so that it plays well with the removal of
of_can_translate_address()

