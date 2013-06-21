Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422764Ab3FUGRc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 02:17:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:14478 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758175Ab3FUGRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 02:17:31 -0400
X-IronPort-AV: E=Sophos;i="4.87,910,1363104000"; 
   d="scan'208";a="7624791"
Message-ID: <51C3F0AC.5020006@cn.fujitsu.com>
Date: Fri, 21 Jun 2013 14:20:28 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: tglx@linutronix.de, mingo@elte.hu, akpm@linux-foundation.org,
        tj@kernel.org, trenn@suse.de, yinghai@kernel.org, jiang.liu@huawei.com,
        wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Toshi Kani <toshi.kani@hp.com>
Subject: Re: [Part1 PATCH v5 00/22] x86, ACPI, numa: Parse numa info earlier
References: <1371128589-8953-1-git-send-email-tangchen@cn.fujitsu.com> <51C3E276.8030804@zytor.com> <51C3ED76.3040900@cn.fujitsu.com> <51C3EE54.4060707@zytor.com>
In-Reply-To: <51C3EE54.4060707@zytor.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/21 14:16:18,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/21 14:16:22,
	Serialize complete at 2013/06/21 14:16:22
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2013 02:10 PM, H. Peter Anvin wrote:
> On 06/20/2013 11:06 PM, Tang Chen wrote:
>>
>> Hi hpa,
>>
>> The build problem has been fixed by Yinghai.
>>
>
> Where?  I don't see anything that is obviously a fix in my inbox.
>

Yinghai resent a new version to fix the problem.
https://lkml.org/lkml/2013/6/14/561

> What about Tejun's feedback?

tj's comments were after the latest version. So we need to
restructure the patch-set.

>
> 	-hpa
>
>
