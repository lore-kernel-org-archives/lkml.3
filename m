Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721Ab3HBBeb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 21:34:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:19967 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752966Ab3HBBea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 21:34:30 -0400
X-IronPort-AV: E=Sophos;i="4.89,797,1367942400"; 
   d="scan'208";a="8093315"
Message-ID: <51FB0C49.3090603@cn.fujitsu.com>
Date: Fri, 02 Aug 2013 09:32:57 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: rjw@sisk.pl, lenb@kernel.org, tglx@linutronix.de, mingo@elte.hu,
        hpa@zytor.com, akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com,
        zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 03/18] acpi: Remove "continue" in macro INVALID_TABLE().
References: <1375340800-19332-1-git-send-email-tangchen@cn.fujitsu.com>  <1375340800-19332-4-git-send-email-tangchen@cn.fujitsu.com> <1375394806.10300.24.camel@misato.fc.hp.com>
In-Reply-To: <1375394806.10300.24.camel@misato.fc.hp.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/02 09:33:07,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/02 09:33:13,
	Serialize complete at 2013/08/02 09:33:13
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2013 06:06 AM, Toshi Kani wrote:
......
>>   /* Non-fatal errors: Affected tables/files are ignored */
>>   #define INVALID_TABLE(x, path, name)					\
>
> Since you are touching this macro, I'd suggest to rename it something
> like ACPI_INVALID_TABLE().  INVALID_TABLE() sounds too generic to me.
> Otherwise, it looks good.

Hi Toshi-san,

Thanks for your advice and ack, will change the name.

Thanks.

>
> Acked-by: Toshi Kani<toshi.kani@hp.com>

