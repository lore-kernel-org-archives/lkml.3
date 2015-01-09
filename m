Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933301AbbAIKvG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:51:06 -0500
Received: from sism000.sis.com ([210.242.182.187]:24892 "EHLO sism02.sis.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756177AbbAIKvD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:51:03 -0500
X-Greylist: delayed 884 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Jan 2015 05:51:02 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="big5"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH 0/2] INPUT/HID: add touch support for SiS touch driver
Date: Fri, 9 Jan 2015 18:36:10 +0800
Message-ID: <8322374EB97AA24A95D0DDBFC8F1CA1DBF96E8@SISMBEV01.sis.com.tw>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 0/2] INPUT/HID: add touch support for SiS touch driver
Thread-Index: AdAr+BWiYhbxNVlVRReOBhTKECqLcQ==
From: =?big5?B?tL+0QN+7ICh0YW1teV90c2VuZyk=?= <tammy_tseng@sis.com>
To: <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>
Cc: <tammy0524@gmail.com>
X-OriginalArrivalTime: 09 Jan 2015 10:36:11.0829 (UTC) FILETIME=[16365E50:01D02BF8]
X-TM-AS-Product-Ver: SMEX-10.2.0.3176-7.500.1018-21236.003
X-TM-AS-Result: No--4.135100-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-Received-IP: 192.168.50.86
X-Envelope-From: <tammy_tseng@sis.com>
X-Sherlock-Send: MailFilter (sism02.sis.com)
X-License: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
This package of patch is to add support for multitouch behavior for SiS touch products.
The first patch adds i2c multitouch behavior in input/touchscreen.
The second patch merges char-device for fw-communication functions in hid-multitouch.c and adds files of functions in hid.

Signed-off-by: Tammy Tseng <tammy_tseng@sis.com>

---
The patch for i2c multitouch driver in input/touchscreen:

linux-3.18.1/drivers/input/touchscreen/Kconfig   |   14 -
 linux-3.18.1/drivers/input/touchscreen/Makefile  |    4 -
 linux-3.18.1/drivers/input/touchscreen/sis_i2c.c | 1725 ----------------------
 linux-3.18.1/drivers/input/touchscreen/sis_i2c.h |  229 ---
 4 files changed, 1972 deletions(-)

The patch for hid multitouch driver in hid:

linux-3.18.1/drivers/hid/Kconfig          |  30 +--
 linux-3.18.1/drivers/hid/Makefile         |   1 -
 linux-3.18.1/drivers/hid/hid-ids.h        |   1 -
 linux-3.18.1/drivers/hid/hid-multitouch.c |  19 +-
 linux-3.18.1/drivers/hid/hid-sis_ctrl.c   | 397 ------------------------------
 linux-3.18.1/drivers/hid/hid-sis_ctrl.h   |  19 --
 6 files changed, 2 insertions(+), 465 deletions(-)


Thanks,
Tammy Tseng

