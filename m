Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab3GYGkr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 02:40:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:40238 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751436Ab3GYGko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 02:40:44 -0400
X-IronPort-AV: E=Sophos;i="4.89,741,1367942400"; 
   d="scan'208";a="8016998"
Message-ID: <51F0C8ED.3070200@cn.fujitsu.com>
Date: Thu, 25 Jul 2013 14:42:53 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
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
Subject: Re: [PATCH 02/21] memblock, numa: Introduce flag into memblock.
References: <1374220774-29974-1-git-send-email-tangchen@cn.fujitsu.com> <1374220774-29974-3-git-send-email-tangchen@cn.fujitsu.com> <20130723190928.GH21100@mtj.dyndns.org> <51EF4196.8050303@cn.fujitsu.com> <20130724155458.GA20377@mtj.dyndns.org>
In-Reply-To: <20130724155458.GA20377@mtj.dyndns.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/25 14:38:04,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/25 14:38:28,
	Serialize complete at 2013/07/25 14:38:28
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2013 11:54 PM, Tejun Heo wrote:
> On Wed, Jul 24, 2013 at 10:53:10AM +0800, Tang Chen wrote:
>>> Let's please drop "with" and do we really need to print full 16
>>> digits?
>>
>> Sure, will remove "with". But I think printing out the full flags is batter.
>> The output seems more tidy.
>
> I mean, padding is fine but you can just print out 4 or even 2 digits
> and will be fine for the foreseeable future.

OK. In this patch-set, there won't more than two flags. I think one 
hexadecimal
number is enough. I'll print two digits for the foreseeable future.

Thanks.

