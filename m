Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab3EIIT7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 04:19:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:62855 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305Ab3EIIT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 04:19:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,639,1363158000"; 
   d="scan'208";a="334185135"
From: "Ren, Qiaowei" <qiaowei.ren@intel.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>
Subject: RE: [PATCH 0/4] Intel TXT driver
Thread-Topic: [PATCH 0/4] Intel TXT driver
Thread-Index: AQHOS5PFgzEwU6db/EypzzlKvzNy6Jj8gqQQ
Date: Thu, 9 May 2013 08:19:51 +0000
Message-ID: <9E0BE1322F2F2246BD820DA9FC397ADE9AAC26@SHSMSX102.ccr.corp.intel.com>
References: <1367938519-840-1-git-send-email-qiaowei.ren@intel.com>
 <1367980128.2425.3.camel@x230>
In-Reply-To: <1367980128.2425.3.camel@x230>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r498K9vN014034

On 2013-05-08, Matthew Garrett wrote:
> On Tue, 2013-05-07 at 22:55 +0800, Qiaowei Ren wrote:
>> This module is expected to be a better tool to access below resources
>>   - TXT config space
>>   - Tboot log mem
>>   - SMX parameter
> 
> What's SMX?

Safer Mode Extensions (SMX) provide a programming interface for system software to establish a measured environment within the platform to support trust decisions by end users. SMX functionality is provided in an Intel 64 processor through the GETSEC instruction via leaf functions.

Thanks,
Qiaowei

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
