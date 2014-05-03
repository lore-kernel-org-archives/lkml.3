Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbaECUTv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 16:19:51 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:18110 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbaECUTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 16:19:49 -0400
Date: Sat, 3 May 2014 23:19:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] staging: rtl8723au: fix some confusing indenting
Message-ID: <20140503201919.GB32753@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The break and the "unknown++" are at the same indent level so my static
checker complains.  The if statement should be indented more.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
index eb7b98e..4ad80e7 100644
--- a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
@@ -1235,8 +1235,8 @@ static int rtw_validate_frame_ies(const u8 *start, uint len)
 		case WLAN_EID_ERP_INFO:
 		case WLAN_EID_EXT_SUPP_RATES:
 		case WLAN_EID_VENDOR_SPECIFIC:
-		if (rtw_validate_vendor_specific_ies(pos, elen))
-			unknown++;
+			if (rtw_validate_vendor_specific_ies(pos, elen))
+				unknown++;
 			break;
 		case WLAN_EID_RSN:
 		case WLAN_EID_PWR_CAPABILITY:
