Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbbAEPnu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 10:43:50 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:59871 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436AbbAEPns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 10:43:48 -0500
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Jiri Kosina <trivial@kernel.org>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: [RESEND PATCH 3.19-rc2] of: Fix brace position for struct of_device_id definition
Date: Mon,  5 Jan 2015 15:43:39 +0000
Message-Id: <1420472619-7364-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1414072430-29251-1-git-send-email-daniel.thompson@linaro.org>
References: <1414072430-29251-1-git-send-email-daniel.thompson@linaro.org>
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
index 745def862580..bbf85d612be5 100644
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

