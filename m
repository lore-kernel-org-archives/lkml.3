Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279AbaGDVU2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 17:20:28 -0400
Received: from mail.efficios.com ([78.47.125.74]:41028 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753535AbaGDVU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 17:20:27 -0400
Date: Fri, 4 Jul 2014 21:20:28 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: gregkh <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-ID: <1983136768.8892.1404508828693.JavaMail.zimbra@efficios.com>
In-Reply-To: <1086604719.8856.1404508237223.JavaMail.zimbra@efficios.com>
Subject: Qualcomm "All Rights Reserved" in Linux staging
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [173.246.29.13]
X-Mailer: Zimbra 8.0.7_GA_6021 (ZimbraWebClient - FF30 (Linux)/8.0.7_GA_6021)
Thread-Topic: Qualcomm "All Rights Reserved" in Linux staging
Thread-Index: tgcKZKbNVfJceP4iPxp9HIhuQxSLBQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Reading this story about Qualcomm lawyers shooting
DMCA takedown requests lightly against github projects:

http://linux.slashdot.org/story/14/07/04/1455200/qualcomm-takes-down-100-github-repositories-with-dmca-notice
http://www.phoronix.com/scan.php?page=news_item&px=MTczNDU
https://github.com/github/dmca/blob/master/2014-07-02-Qualcomm.md

It appears to me that the mere presence of those lines
in Linux staging:

grep -r "Qualcomm" . |grep -i "rights"
./drivers/staging/ft1000/ft1000-usb/ft1000_usb.c: * CopyRight (C) 2007 Qualcomm Inc. All Rights Reserved.
./drivers/staging/ft1000/ft1000-usb/ft1000_download.c:* CopyRight (C) 2007 Qualcomm Inc. All Rights Reserved.
./drivers/staging/ft1000/ft1000-usb/ft1000_hw.c:/* CopyRight (C) 2007 Qualcomm Inc. All Rights Reserved.

might be contradicting the Dual MPL/GPL license
expressed by MODULE_LICENSE() for those files.
Perhaps we should ask some clarification on
licensing of those files to Qualcomm ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
