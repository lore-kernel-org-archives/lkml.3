Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000AbaJWNyO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 09:54:14 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:34262 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbaJWNyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 09:54:10 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Jiri Kosina <trivial@kernel.org>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: [PATCH] of: Fix brace position for struct of_device_id definition
Date: Thu, 23 Oct 2014 14:53:50 +0100
Message-Id: <1414072430-29251-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently it is not easy to grep for the definition of struct of_device_id.
This is trivially fixed by moving the brace to the right place.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
---
 include/linux/mod_devicetable.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 44eeef0..0acc82d 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -220,8 +220,7 @@ struct serio_device_id {
 /*
  * Struct used for matching a device
  */
-struct of_device_id
-{
+struct of_device_id {
 	char	name[32];
 	char	type[32];
 	char	compatible[128];
--
1.9.3

