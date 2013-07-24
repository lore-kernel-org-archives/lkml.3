Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507Ab3GXDSJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 23:18:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:20109 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751215Ab3GXDSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 23:18:06 -0400
X-IronPort-AV: E=Sophos;i="4.89,732,1367942400"; 
   d="scan'208";a="8000209"
Message-ID: <51EF4806.7070805@cn.fujitsu.com>
Date: Wed, 24 Jul 2013 11:20:38 +0800
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
Subject: Re: [PATCH 10/21] earlycpio.c: Fix the confusing comment of find_cpio_data().
References: <1374220774-29974-1-git-send-email-tangchen@cn.fujitsu.com> <1374220774-29974-11-git-send-email-tangchen@cn.fujitsu.com> <20130723200227.GO21100@mtj.dyndns.org>
In-Reply-To: <20130723200227.GO21100@mtj.dyndns.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/24 11:15:50,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/24 11:16:03,
	Serialize complete at 2013/07/24 11:16:03
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2013 04:02 AM, Tejun Heo wrote:
> On Fri, Jul 19, 2013 at 03:59:23PM +0800, Tang Chen wrote:
>> - * @offset: When a matching file is found, this is the offset to the
>> - *          beginning of the cpio. It can be used to iterate through
>> - *          the cpio to find all files inside of a directory path
>> + * @offset: When a matching file is found, this is the offset from the
>> + *          beginning of the cpio to the beginning of the next file, not the
>> + *          matching file itself. It can be used to iterate through the cpio
>> + *          to find all files inside of a directory path
>
> Nicely spotted.  I think we can go further and rename it to @nextoff.

OK, followed.

Thanks.
