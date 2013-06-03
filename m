Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab3FCHea (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 03:34:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60951 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751197Ab3FCHeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 03:34:22 -0400
X-IronPort-AV: E=Sophos;i="4.87,791,1363104000"; 
   d="scan'208";a="7444161"
Message-ID: <51AC47A2.6020108@cn.fujitsu.com>
Date: Mon, 03 Jun 2013 15:37:06 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
CC: mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, tj@kernel.org,
        mgorman@suse.de, minchan@kernel.org, mina86@mina86.com,
        gong.chen@linux.intel.com, vasilis.liaskovitis@profitbricks.com,
        lwoodman@redhat.com, riel@redhat.com, jweiner@redhat.com,
        prarit@redhat.com, x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 12/13] x86, numa, acpi, memory-hotplug: Make movablecore=acpi
 have higher priority.
References: <1369387762-17865-1-git-send-email-tangchen@cn.fujitsu.com> <1369387762-17865-13-git-send-email-tangchen@cn.fujitsu.com> <20130603025924.GB7441@hacker.(null)>
In-Reply-To: <20130603025924.GB7441@hacker.(null)>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/03 15:32:34,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/03 15:32:43,
	Serialize complete at 2013/06/03 15:32:43
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2013 10:59 AM, Wanpeng Li wrote:
> On Fri, May 24, 2013 at 05:29:21PM +0800, Tang Chen wrote:
>> Arrange hotpluggable memory as ZONE_MOVABLE will cause NUMA performance decreased
>> because the kernel cannot use movable memory.
>>
>> For users who don't use memory hotplug and who don't want to lose their NUMA
>> performance, they need a way to disable this functionality.
>>
>> So, if users specify "movablecore=acpi" in kernel commandline, the kernel will
>> use SRAT to arrange ZONE_MOVABLE, and it has higher priority then original
>> movablecore and kernelcore boot option.
>>
>> For those who don't want this, just specify nothing.
>>
>
> Reviewed-by: Wanpeng Li<liwanp@linux.vnet.ibm.com>

Thank you very much for reviewing these patches. :)

