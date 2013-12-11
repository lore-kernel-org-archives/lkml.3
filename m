Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751656Ab3LKLQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 06:16:17 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:35336 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab3LKLQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 06:16:16 -0500
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH 0/5] Remove deprecates usage of device_type
Date: Wed, 11 Dec 2013 11:15:50 +0000
Message-Id: <1386760555-22732-1-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I spent some time this morning to clear out a bunch of unnecessary
references to device_type in dt bindings. There is still a lot to do.
"serial" has a lot of unnecessary users, and the are three bindings that
use "network" that probably can be relaxed. However, I think this is a
good first step.

Grant Likely (5):
      dt/bindings: Remove all references to device_type "ethernet-phy"
      dt/bindings: Remove references to linux,phandle properties
      dt/bindings: remove users of device_type "mdio"
      dt/bindings: remove device_type "network" references
      dt/bindings: Remove device_type "serial" from marvell,mv64360-mpsc


