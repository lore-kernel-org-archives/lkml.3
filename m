Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560Ab3CGRNq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 12:13:46 -0500
Received: from mta-blr1.sasken.com ([203.200.200.72]:49709 "EHLO
	mta-blr1.sasken.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756089Ab3CGRNp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 12:13:45 -0500
X-Greylist: delayed 600 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Mar 2013 12:13:44 EST
From: Vishnu Banavath <vishnu.banavath@sasken.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 7 Mar 2013 22:33:42 +0530
Subject: sysrq emergency remount r o
Thread-Topic: sysrq emergency remount r o
Thread-Index: AQHOG1W427DBCHNie0ygsUM1hg/Qpw==
Message-ID: <47D610AD9C485E458630BA38C324D3B6013BF77D2A93@EXGMBX01.sasken.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, en-IN
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
when I'm trying to do suspend/resume for several times and after  ~20 times I perform this operation I see device reboot with
<6>SysRq : Emergency Remount R/O
<6>EXT4-fs (mmcblk0p12): re-mounted. Opts: (null)

I'm not sure what caused the device to reboot.
What would be the typical scenario device does this reboot.

Regards,
Vishu

SASKEN BUSINESS DISCLAIMER: This message may contain confidential, proprietary or legally privileged information. In case you are not the original intended Recipient of the message, you must not, directly or indirectly, use, disclose, distribute, print, or copy any part of this message and you are requested to delete it and inform the sender. Any views expressed in this message are those of the individual sender unless otherwise stated. Nothing contained in this message shall be construed as an offer or acceptance of any offer by Sasken Communication Technologies Limited ("Sasken") unless sent with that express intent and with due authority of Sasken. Sasken has taken enough precautions to prevent the spread of viruses. However the company accepts no liability for any damage caused by any virus transmitted by this email.
Read Disclaimer at http://www.sasken.com/extras/mail_disclaimer.html
