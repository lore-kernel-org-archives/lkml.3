Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934047AbaGXB14 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 21:27:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:63260 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757852AbaGXB1u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 21:27:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,721,1400050800"; 
   d="scan'208";a="577976099"
From: "Ren, Qiaowei" <qiaowei.ren@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
CC: "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: RE: [PATCH v7 09/10] x86, mpx: cleanup unused bound tables
Thread-Topic: [PATCH v7 09/10] x86, mpx: cleanup unused bound tables
Thread-Index: AQHPpKaiWp0ck2giqEe4I+NwpoujZZutWZiAgAEPVnD//34ngIAAiknA
Date: Thu, 24 Jul 2014 01:27:28 +0000
Message-ID: <9E0BE1322F2F2246BD820DA9FC397ADE01703090@shsmsx102.ccr.corp.intel.com>
References: <1405921124-4230-1-git-send-email-qiaowei.ren@intel.com>
 <1405921124-4230-10-git-send-email-qiaowei.ren@intel.com>
 <53CFE4F9.3000701@intel.com>
 <9E0BE1322F2F2246BD820DA9FC397ADE01703006@shsmsx102.ccr.corp.intel.com>
 <53D05BA9.1040108@intel.com>
In-Reply-To: <53D05BA9.1040108@intel.com>
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



On 2014-07-24, Hansen, Dave wrote:
> On 07/23/2014 05:49 PM, Ren, Qiaowei wrote:
>> I can check a lot of debug information when one VMA and related
>> bounds tables are allocated and freed through adding a lot of
>> print() like log into kernel/runtime. Do you think this is enough?
> 
> I thought the entire reason we grabbed a VM_ flag was to make it
> possible to figure out without resorting to this.

All cleanup work certainly depends on this VM_ flag. In addition, as we discussed, this new VM_ flag can mainly have runtime know how much memory is occupied by MPX.

Thanks,
Qiaowei

