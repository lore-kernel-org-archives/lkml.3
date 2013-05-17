Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab3EQIuR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 04:50:17 -0400
Received: from mga14.intel.com ([143.182.124.37]:14422 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754493Ab3EQIuO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 04:50:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,690,1363158000"; 
   d="scan'208";a="242918980"
From: "Ren, Qiaowei" <qiaowei.ren@intel.com>
To: Pavel Machek <pavel@ucw.cz>
CC: Matthew Garrett <matthew.garrett@nebula.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "Wei, Gang" <gang.wei@intel.com>, Greg KH <greg@kroah.com>
Subject: RE: [PATCH v2 2/3] driver: provide sysfs interfaces to access TXT
 config space
Thread-Topic: [PATCH v2 2/3] driver: provide sysfs interfaces to access TXT
 config space
Thread-Index: AQHOT70fNvMSPAhjXUm++YIFBSpTUZkHeCQAgAGc4fA=
Date: Fri, 17 May 2013 08:50:11 +0000
Message-ID: <9E0BE1322F2F2246BD820DA9FC397ADE0135DF81@SHSMSX102.ccr.corp.intel.com>
References: <1368465884-14779-1-git-send-email-qiaowei.ren@intel.com>
 <1368465884-14779-3-git-send-email-qiaowei.ren@intel.com>
 <20130516160311.GA12299@amd.pavel.ucw.cz>
In-Reply-To: <20130516160311.GA12299@amd.pavel.ucw.cz>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-05-17, Pavel Machek wrote:
> On Tue 2013-05-14 01:24:43, Qiaowei Ren wrote:
>> +What:		/sys/devices/platform/intel_txt/config/STS_raw +Date:		May 2013
>> +KernelVersion:	3.9 +Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
>> +Description:	TXT.STS is the general status register. This read-only
>> register +		is used by AC modules and the MLE to get the status of
>> various +		Intel TXT features.
> 
> This is not enough to allow people to understand what this does/should
> do, nor does it allow (for example) ARM people to implement something compatible.

Currently TXT is only a technology for safer computing provided by Intel. I am absolutely not sure whether similar technology will be provided on ARM or other platform in future. But I guess I don't have to consider those future possible implementation on ARM or other platform. :)

Thanks,
Qiaowei
