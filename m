Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab3CXGb0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 02:31:26 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:48802 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab3CXGbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 02:31:24 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org, mchehab@redhat.com,
        linux-media@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] documentation: DocBook/media : Fix typo in dvbproperty.xml
Date: Sun, 24 Mar 2013 15:25:56 +0900
Message-Id: <1364106356-27779-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.2.135.g7b592fa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typos.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/DocBook/media/dvb/dvbproperty.xml | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index 4a5eaee..31dc4df 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -1,6 +1,6 @@
 <section id="FE_GET_SET_PROPERTY">
 <title><constant>FE_GET_PROPERTY/FE_SET_PROPERTY</constant></title>
-<para>This section describes the DVB version 5 extention of the DVB-API, also
+<para>This section describes the DVB version 5 extension of the DVB-API, also
 called "S2API", as this API were added to provide support for DVB-S2. It was
 designed to be able to replace the old frontend API. Yet, the DISEQC and
 the capability ioctls weren't implemented yet via the new way.</para>
@@ -952,7 +952,7 @@ enum fe_interleaving {
 		<para>Measures the amount of bits received before the inner code block, during the same period as
 		<link linkend="DTV-STAT-PRE-ERROR-BIT-COUNT"><constant>DTV_STAT_PRE_ERROR_BIT_COUNT</constant></link> measurement was taken.</para>
 		<para>It should be noticed that this measurement can be smaller than the total amount of bits on the transport stream,
-		      as the frontend may need to manually restart the measurement, loosing some data between each measurement interval.</para>
+		      as the frontend may need to manually restart the measurement, losing some data between each measurement interval.</para>
 		<para>This measurement is monotonically increased, as the frontend gets more bit count measurements.
 		      The frontend may reset it when a channel/transponder is tuned.</para>
 		<para>Possible scales for this metric are:</para>
@@ -981,7 +981,7 @@ enum fe_interleaving {
 		<para>Measures the amount of bits received after the inner coding, during the same period as
 		<link linkend="DTV-STAT-POST-ERROR-BIT-COUNT"><constant>DTV_STAT_POST_ERROR_BIT_COUNT</constant></link> measurement was taken.</para>
 		<para>It should be noticed that this measurement can be smaller than the total amount of bits on the transport stream,
-		      as the frontend may need to manually restart the measurement, loosing some data between each measurement interval.</para>
+		      as the frontend may need to manually restart the measurement, losing some data between each measurement interval.</para>
 		<para>This measurement is monotonically increased, as the frontend gets more bit count measurements.
 		      The frontend may reset it when a channel/transponder is tuned.</para>
 		<para>Possible scales for this metric are:</para>
-- 
1.8.2.135.g7b592fa

