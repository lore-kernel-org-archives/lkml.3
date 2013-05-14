Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab3ENBuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 21:50:04 -0400
Received: from mga03.intel.com ([143.182.124.21]:52899 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755578Ab3ENBuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 21:50:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,666,1363158000"; 
   d="scan'208";a="301996368"
From: "Ren, Qiaowei" <qiaowei.ren@intel.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "Wei, Gang" <gang.wei@intel.com>
Subject: RE: [PATCH v2 1/3] driver: add TXT driver in kernel
Thread-Topic: [PATCH v2 1/3] driver: add TXT driver in kernel
Thread-Index: AQHOT70ce8pRQUVuo0iGkdOETVTL+5kC2dkAgAERGwA=
Date: Tue, 14 May 2013 01:49:56 +0000
Message-ID: <9E0BE1322F2F2246BD820DA9FC397ADE9AE80A@SHSMSX102.ccr.corp.intel.com>
References: <1368465884-14779-1-git-send-email-qiaowei.ren@intel.com>
	 <1368465884-14779-2-git-send-email-qiaowei.ren@intel.com>
 <1368466296.2425.48.camel@x230>
In-Reply-To: <1368466296.2425.48.camel@x230>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4E1oAqs004649

On 2013-05-14, Matthew Garrett wrote:
> On Tue, 2013-05-14 at 01:24 +0800, Qiaowei Ren wrote:
> > static int __init txt_sysfs_init(void)
> > +{
> > +	if (!tboot_enabled())
> > +		return -ENODEV;
> 
> If there's a CPU flag that indicates tboot support, you should add a modalias for
> it in order to ensure that the module gets automatically loaded.

Ok.

Thanks,
Qiaowei
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
