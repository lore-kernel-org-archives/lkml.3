Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335AbaGQH3C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 03:29:02 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42056 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbaGQH3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 03:29:00 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <53C77AE4.1040602@jp.fujitsu.com>
Date: Thu, 17 Jul 2014 16:27:32 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Chen, Gong" <gong.chen@linux.intel.com>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <x86@kernel.org>, <toshi.kani@hp.com>, <imammedo@redhat.com>,
        <bp@alien8.de>, <huawei.libin@huawei.com>,
        <paul.gortmaker@windriver.com>, <linux-kernel@vger.kernel.org>,
        <srivatsa.bhat@linux.vnet.ibm.com>, <umgwanakikbuti@gmail.com>,
        <peterz@infradead.org>
Subject: Re: [PATCH v2] x86,cpu-hotplug: assign same CPU number to readded
 CPU
References: <53C62AAF.7060509@jp.fujitsu.com> <20140717063438.GA2311@gchen.bj.intel.com>
In-Reply-To: <20140717063438.GA2311@gchen.bj.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/07/17 15:34), Chen, Gong wrote:
> On Wed, Jul 16, 2014 at 04:33:03PM +0900, Yasuaki Ishimatsu wrote:
> [...]
>> + * Bind ACPI ID to Logical CPU number
>             ^^^^
>             APIC
>

Thank you for your review.
I'll update soon.

Thanks,
Yasauaki Ishimatsu

