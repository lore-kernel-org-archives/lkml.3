Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab3A1JQs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 04:16:48 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51394 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753148Ab3A1JQq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 04:16:46 -0500
X-IronPort-AV: E=Sophos;i="4.84,551,1355068800"; 
   d="scan'208";a="6654563"
Message-ID: <510641CC.9040707@cn.fujitsu.com>
Date: Mon, 28 Jan 2013 17:15:56 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: jiang.liu@huawei.com, wujianguo@huawei.com, hpa@zytor.com,
        wency@cn.fujitsu.com, laijs@cn.fujitsu.com, linfeng@cn.fujitsu.com,
        yinghai@kernel.org, isimatu.yasuaki@jp.fujitsu.com, rob@landley.net,
        kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, mgorman@suse.de,
        rientjes@google.com, guz.fnst@cn.fujitsu.com, rusty@rustcorp.com.au,
        lliubbo@gmail.com, jaegeuk.hanse@gmail.com, tony.luck@intel.com,
        glommer@parallels.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 3/3] acpi, memory-hotplug: Support getting hotplug info
 from SRAT.
References: <1359106929-3034-1-git-send-email-tangchen@cn.fujitsu.com> <1359106929-3034-4-git-send-email-tangchen@cn.fujitsu.com> <20130125171230.34c5a273.akpm@linux-foundation.org>
In-Reply-To: <20130125171230.34c5a273.akpm@linux-foundation.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/28 17:15:38,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/28 17:15:40
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2013 09:12 AM, Andrew Morton wrote:
> On Fri, 25 Jan 2013 17:42:09 +0800
> Tang Chen<tangchen@cn.fujitsu.com>  wrote:
>
>> NOTE: Using this way will cause NUMA performance down because the whole node
>>        will be set as ZONE_MOVABLE, and kernel cannot use memory on it.
>>        If users don't want to lose NUMA performance, just don't use it.
>
> I agree with this, but it means that nobody will test any of your new code.
>
> To get improved testing coverage, can you think of any temporary
> testing-only patch which will cause testers to exercise the
> memory-hotplug changes?

Hi Andrew,

OK，I‘ll think about it and post the testing patch. But I think a shell 
script
may be easier because the boot option is specified by user and the code 
only runs
when system is booting. So we need to reboot the system all the time.

Thanks. :)
