Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab3EKABr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 20:01:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:7790 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732Ab3EKABq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 20:01:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,651,1363158000"; 
   d="scan'208";a="300730260"
From: "Ren, Qiaowei" <qiaowei.ren@intel.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "Wei, Gang" <gang.wei@intel.com>
Subject: RE: [PATCH 4/4] driver: provide sysfs interfaces to access SMX
 parameter
Thread-Topic: [PATCH 4/4] driver: provide sysfs interfaces to access SMX
 parameter
Thread-Index: AQHOSvE+ysMfIHdI9EqG5gcExdaKwpj6wt+AgAMpG0CAAHzgAIAAtDeg
Date: Sat, 11 May 2013 00:01:38 +0000
Message-ID: <9E0BE1322F2F2246BD820DA9FC397ADE9AD2A2@SHSMSX102.ccr.corp.intel.com>
References: <1367938519-840-1-git-send-email-qiaowei.ren@intel.com>
	 <1367938519-840-5-git-send-email-qiaowei.ren@intel.com>
	 <1367990697.2425.33.camel@x230>
	 <9E0BE1322F2F2246BD820DA9FC397ADE9AC926@SHSMSX102.ccr.corp.intel.com>
 <1368191268.2425.38.camel@x230>
In-Reply-To: <1368191268.2425.38.camel@x230>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4B01vE1025182

On 2013-05-10, Matthew Garrett wrote:
> On Fri, 2013-05-10 at 07:05 +0000, Ren, Qiaowei wrote:
>> On 2013-05-08, Matthew Garrett wrote:
>>> On Tue, 2013-05-07 at 22:55 +0800, Qiaowei Ren wrote:
>>> 
>>>> +What:		/sys/devices/platform/intel_txt/parameter/acm_max_size
>>>> +Date:		May 2013
>>>> +KernelVersion:	3.9
>>>> +Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
>>>> +Description:	The "acm_max_size" property will show max size of
>>>> +		authenticated code execution area.
>>> 
>>> What would userspace use this for?
>> 
>> These sysfs files are just export SMX & TXT related information to userspace.
> So that other developers (or OSV & ISV) can be able to develop txt
> related applications or tools based on these information.
> 
> If they're only using it for debugging purposes then sysfs probably
> isn't the right place. Is there any reason tools would need to know this during normal usage?

Unlike tboot log, these properties are not used for debugging purposes.
They are used to report attributes, options and limitations of SMX operation. Software may use them to identify operations limits or additional options.

Thanks,
Qiaowei

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
