Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab3KLJnf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 04:43:35 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:63540 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab3KLJna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 04:43:30 -0500
From: Eric Skoglund <ericskog@gmail.com>
To: gregkh@linuxfoundation.org
Cc: shaun@xresource.ca, dulshani.gunawardhana89@gmail.com,
        sachin.kamat@linaro.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Eric Skoglund <eric@pagefault.se>
Subject: [PATCH 2/3] Drivers: Staging: cxt1e1: sbeid: Fixed braces coding style issue
Date: Tue, 12 Nov 2013 10:42:22 +0100
Message-Id: <1384249343-10468-2-git-send-email-ericskog@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1384249343-10468-1-git-send-email-ericskog@gmail.com>
References: <1384249343-10468-1-git-send-email-ericskog@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Skoglund <eric@pagefault.se>

This patch fixes a brace coding style issue.

Signed-off-by: Eric Skoglund <eric@pagefault.se>
---
 drivers/staging/cxt1e1/sbeid.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/cxt1e1/sbeid.c b/drivers/staging/cxt1e1/sbeid.c
index 75efbc3..bf6c943 100644
--- a/drivers/staging/cxt1e1/sbeid.c
+++ b/drivers/staging/cxt1e1/sbeid.c
@@ -24,8 +24,7 @@ sbeid_get_bdname (ci_t *ci)
 {
 	char       *np = NULL;
 
-	switch (ci->brd_id)
-	{
+	switch (ci->brd_id) {
 	case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPTMC_256T3_E1):
 		np = "wanPTMC-256T3 <E1>";
 		break;
@@ -73,8 +72,7 @@ sbeid_set_hdwbid (ci_t *ci)
 	 * have this register implemented)
 	 */
 
-	switch (ci->brd_id)
-	{
+	switch (ci->brd_id) {
         case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPTMC_256T3_E1):
 		ci->hdw_bid = SBE_BID_256T3_E1; /* 0x46 - SBE wanPTMC-256T3 (E1
 						 * Version) */
@@ -89,8 +87,7 @@ sbeid_set_hdwbid (ci_t *ci)
 		 * This Board ID is a generic identification.  Use the found number
 		 * of ports to further define this hardware.
 		 */
-		switch (ci->max_port)
-		{
+		switch (ci->max_port) {
 		default:                    /* shouldn't need a default, but have one
 					     * anyway */
 		case 4:
@@ -130,8 +127,7 @@ sbeid_set_hdwbid (ci_t *ci)
 		 * This Board ID is a generic identification.  Use the number of
 		 * found ports to further define this hardware.
 		 */
-		switch (ci->max_port)
-		{
+		switch (ci->max_port) {
 		default:                    /* shouldn't need a default, but have one
 					     * anyway */
 		case 4:
@@ -166,8 +162,7 @@ void
 sbeid_set_bdtype (ci_t *ci)
 {
 	/* set SBE's unique PCI VENDOR/DEVID */
-	switch (ci->hdw_bid)
-	{
+	switch (ci->hdw_bid) {
         case SBE_BID_C1T3:      /* SBE wanPMC-C1T3 */
 		ci->brd_id = SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C1T3);
 		break;
-- 
1.8.3.1

