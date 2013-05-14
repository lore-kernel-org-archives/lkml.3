Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806Ab3ENBrI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 21:47:08 -0400
Received: from mga03.intel.com ([143.182.124.21]:17348 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755499Ab3ENBrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 21:47:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,666,1363158000"; 
   d="scan'208";a="241068021"
From: "Ren, Qiaowei" <qiaowei.ren@intel.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "Wei, Gang" <gang.wei@intel.com>
Subject: RE: [PATCH v2 2/3] driver: provide sysfs interfaces to access TXT
 config space
Thread-Topic: [PATCH v2 2/3] driver: provide sysfs interfaces to access TXT
 config space
Thread-Index: AQHOT70fNvMSPAhjXUm++YIFBSpTUZkC2teAgAENAuA=
Date: Tue, 14 May 2013 01:46:49 +0000
Message-ID: <9E0BE1322F2F2246BD820DA9FC397ADE9AE7E4@SHSMSX102.ccr.corp.intel.com>
References: <1368465884-14779-1-git-send-email-qiaowei.ren@intel.com>
	 <1368465884-14779-3-git-send-email-qiaowei.ren@intel.com>
 <1368466508.2425.50.camel@x230>
In-Reply-To: <1368466508.2425.50.camel@x230>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4E1lZ8n004636

On 2013-05-14, Matthew Garrett wrote:
> On Tue, 2013-05-14 at 01:24 +0800, Qiaowei Ren wrote:
> > These interfaces are located
> > in /sys/devices/platform/intel_txt/config,
> > and including totally 37 files, providing access to Intel TXT
> > configuration registers.
> 
> Do you have any example userspace code using these features?

You mean test programs using these sysfs files? Currently I just did some simple demos like the following:

cat config/STS_private_open
echo 1 > CMD_CLOSE_PRIVATE
cat config/STS_private_open

cat config/STS_ locality_1_open
echo 1 > CMD_CLOSE_LOCALITY1
cat config/ STS_ locality_1_open
echo 1 > CMD_OPEN_LOCALITY1
cat config/ STS_ locality_1_open

Thanks,
Qiaowei
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
