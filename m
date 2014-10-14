Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbaJNBoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 21:44:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:5449 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753839AbaJNBoS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 21:44:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,714,1406617200"; 
   d="scan'208";a="604831468"
From: "Ren, Qiaowei" <qiaowei.ren@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: RE: [PATCH v7 08/10] x86, mpx: add prctl commands PR_MPX_REGISTER,
 PR_MPX_UNREGISTER
Thread-Topic: [PATCH v7 08/10] x86, mpx: add prctl commands PR_MPX_REGISTER,
 PR_MPX_UNREGISTER
Thread-Index: AQHP5w0XlSa4Yh1zTEmV5IhMByRIY5wu0fGw
Date: Tue, 14 Oct 2014 01:44:16 +0000
Message-ID: <9E0BE1322F2F2246BD820DA9FC397ADE017EB405@shsmsx102.ccr.corp.intel.com>
References: <1405921124-4230-1-git-send-email-qiaowei.ren@intel.com>
	<1405921124-4230-9-git-send-email-qiaowei.ren@intel.com>
 <87lhrn2qfu.fsf@tassilo.jf.intel.com> <543C0EBE.3060702@intel.com>
In-Reply-To: <543C0EBE.3060702@intel.com>
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



On 2014-10-14, Hansen, Dave wrote:
> On 07/20/2014 11:09 PM, Andi Kleen wrote:
>> Qiaowei Ren <qiaowei.ren@intel.com> writes:
>>> This patch adds the PR_MPX_REGISTER and PR_MPX_UNREGISTER prctl()
>>> commands. These commands can be used to register and unregister MPX
>>> related resource on the x86 platform.
>> 
>> Please provide a manpage for the API. This is needed for proper
>> review. Your description is far too vague.
> 
> Qiaowei, have you written this manpage yet?  I see the new patches,
> but no manpage yet.

It will be added into subsequent version or another mainline patchset.

Thanks,
Qiaowei

