Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab3GYDvB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 23:51:01 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:20372 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753484Ab3GYDu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 23:50:58 -0400
X-IronPort-AV: E=Sophos;i="4.89,740,1367942400"; 
   d="scan'208";a="8015299"
Message-ID: <51F0A146.50804@cn.fujitsu.com>
Date: Thu, 25 Jul 2013 11:53:42 +0800
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
Subject: Re: [PATCH 21/21] doc, page_alloc, acpi, mem-hotplug: Add doc for
 movablecore=acpi boot option.
References: <1374220774-29974-1-git-send-email-tangchen@cn.fujitsu.com> <1374220774-29974-22-git-send-email-tangchen@cn.fujitsu.com> <20130723212139.GY21100@mtj.dyndns.org>
In-Reply-To: <20130723212139.GY21100@mtj.dyndns.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/25 11:48:53,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/25 11:48:54,
	Serialize complete at 2013/07/25 11:48:54
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2013 05:21 AM, Tejun Heo wrote:
> On Fri, Jul 19, 2013 at 03:59:34PM +0800, Tang Chen wrote:
>> Since we modify movablecore boot option to support
>> "movablecore=acpi", this patch adds doc for it.
>
> Please fold this into the patch which makes the code chnage.

OK, followed.

Thanks.
