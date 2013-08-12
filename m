Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773Ab3HLO0I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 10:26:08 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:44431 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340Ab3HLO0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 10:26:04 -0400
Message-ID: <5208F06C.8090206@gmail.com>
Date: Mon, 12 Aug 2013 22:25:48 +0800
From: Tang Chen <imtangchen@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Joe Perches <joe@perches.com>, Tang Chen <tangchen@cn.fujitsu.com>,
        robert.moore@intel.com, lv.zheng@intel.com, rjw@sisk.pl,
        lenb@kernel.org, tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, trenn@suse.de, yinghai@kernel.org,
        jiang.liu@huawei.com, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, izumi.taku@jp.fujitsu.com,
        mgorman@suse.de, minchan@kernel.org, mina86@mina86.com,
        gong.chen@linux.intel.com, vasilis.liaskovitis@profitbricks.com,
        lwoodman@redhat.com, riel@redhat.com, jweiner@redhat.com,
        prarit@redhat.com, zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com,
        x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH part2 3/4] acpi: Remove "continue" in macro INVALID_TABLE().
References: <1375938239-18769-1-git-send-email-tangchen@cn.fujitsu.com> <1375938239-18769-4-git-send-email-tangchen@cn.fujitsu.com> <1375939646.2424.132.camel@joe-AO722> <52038C84.4080608@cn.fujitsu.com> <1375970993.2424.142.camel@joe-AO722> <20130812142119.GF15892@htj.dyndns.org>
In-Reply-To: <20130812142119.GF15892@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2013 10:21 PM, Tejun Heo wrote:
> On Thu, Aug 08, 2013 at 07:09:53AM -0700, Joe Perches wrote:
>> If you really think that the #define is better, use
>> something like HW_ERR does and embed that #define
>> in the pr_err.
>>
>> #define ACPI_OVERRIDE	"ACPI OVERRIDE: "
>>
>> 	pr_err(ACPI_OVERRIDE "Table smaller than ACPI header [%s%s]\n",
>> 	       cpio_path, file.name);
>>
>> It's only used a few times by a single file so
>> I think it's unnecessary.
>
> I agree with Joe here.  Just doing normal pr_err() should be enough.
> You can use pr_fmt() to add headers but given that we aren't talking
> about huge number of printks, that probably is an overkill too.

OK, followed.

Thanks.

