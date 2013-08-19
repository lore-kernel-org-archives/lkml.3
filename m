Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751175Ab3HSJOg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 05:14:36 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56941 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab3HSJOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 05:14:34 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <5211E1C3.7090009@jp.fujitsu.com>
Date: Mon, 19 Aug 2013 18:13:39 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Jingbai Ma <jingbai.ma@hp.com>, Fenghua Yu <fenghua.yu@intel.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Mitchell, Lisa (MCLinux in Fort Collins)" <lisa.mitchell@hp.com>,
        "H. Peter Anvin" <hpa@zytor.com>, bhelgaas@google.com,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [Help Test] kdump, x86, acpi: Reproduce CPU0 SMI corruption issue
 after unsetting BSP flag
References: <5200BFB3.2050202@jp.fujitsu.com> <520A10A3.5080303@hp.com> <520B4A22.2030800@hp.com> <87ob90839p.fsf@xmission.com> <5211831B.6090704@jp.fujitsu.com> <a2ff8170-41ad-42f6-9015-850dbe14983d@email.android.com>
In-Reply-To: <a2ff8170-41ad-42f6-9015-850dbe14983d@email.android.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/08/19 11:59), Eric W. Biederman wrote:
>
>
>
>>
>> Sorry Eric, I'm not clear to what you mean by ``short one core''...
>> Which are you suggesting? Disabling BSP if crash happens on AP is
>> reasonable?
>> Or restricting cpus to a single one only just as the current kdump
>> configuration is reasonable?
>
> I am suggesting we start every cpu except the BSP from the AP we started on.
>
> N-1 cpus seems like a good tradeoff between performance and reliability for those who need it.
>
> Eric
>

Thanks. I'm now clear.

Well, I'll post a version 2 patch after upgrading it for current upstream kernel.
But it would be next week or later.

-- 
Thanks.
HATAYAMA, Daisuke

