Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab3HBEuc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 00:50:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:13960 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753563Ab3HBEu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 00:50:28 -0400
X-IronPort-AV: E=Sophos;i="4.89,798,1367942400"; 
   d="scan'208";a="8095320"
Message-ID: <51FB3A36.2080209@cn.fujitsu.com>
Date: Fri, 02 Aug 2013 12:48:54 +0800
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
Subject: Re: [PATCH v2 02/18] earlycpio.c: Fix the confusing comment of find_cpio_data().
References: <1375340800-19332-1-git-send-email-tangchen@cn.fujitsu.com>  <1375340800-19332-3-git-send-email-tangchen@cn.fujitsu.com> <1375394271.10300.18.camel@misato.fc.hp.com>
In-Reply-To: <1375394271.10300.18.camel@misato.fc.hp.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/02 12:49:03,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/02 12:49:10,
	Serialize complete at 2013/08/02 12:49:10
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2013 05:57 AM, Toshi Kani wrote:
......
>>   struct cpio_data __cpuinit find_cpio_data(const char *path, void *data,
>
> This patch does not apply cleanly.  It seems that your branch does not
> have 0db0628d90125193280eabb501c94feaf48fa9ab.
>

I have rebased the patch-set to linux 3.11-rc3. And will resend it later.

Thanks.

