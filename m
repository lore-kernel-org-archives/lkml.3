Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab3AZBbR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 20:31:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48561 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754654Ab3AZBbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 20:31:15 -0500
Message-ID: <51033186.3000706@zytor.com>
Date: Fri, 25 Jan 2013 17:29:42 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Tang Chen <tangchen@cn.fujitsu.com>, jiang.liu@huawei.com,
        wujianguo@huawei.com, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        linfeng@cn.fujitsu.com, yinghai@kernel.org,
        isimatu.yasuaki@jp.fujitsu.com, rob@landley.net,
        kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, mgorman@suse.de,
        rientjes@google.com, guz.fnst@cn.fujitsu.com, rusty@rustcorp.com.au,
        lliubbo@gmail.com, jaegeuk.hanse@gmail.com, tony.luck@intel.com,
        glommer@parallels.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 3/3] acpi, memory-hotplug: Support getting hotplug info
 from SRAT.
References: <1359106929-3034-1-git-send-email-tangchen@cn.fujitsu.com> <1359106929-3034-4-git-send-email-tangchen@cn.fujitsu.com> <20130125171230.34c5a273.akpm@linux-foundation.org>
In-Reply-To: <20130125171230.34c5a273.akpm@linux-foundation.org>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2013 05:12 PM, Andrew Morton wrote:
> On Fri, 25 Jan 2013 17:42:09 +0800
> Tang Chen <tangchen@cn.fujitsu.com> wrote:
> 
>> NOTE: Using this way will cause NUMA performance down because the whole node
>>       will be set as ZONE_MOVABLE, and kernel cannot use memory on it.
>>       If users don't want to lose NUMA performance, just don't use it.
> 
> I agree with this, but it means that nobody will test any of your new code.
> 
> To get improved testing coverage, can you think of any temporary
> testing-only patch which will cause testers to exercise the
> memory-hotplug changes?
> 

There is another problem: if ALL the nodes in the system support
hotpluggable memory, what happens?

	-hpa

