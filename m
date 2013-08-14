Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933285Ab3HNVRK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 17:17:10 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:56069 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932914Ab3HNVRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 17:17:08 -0400
Message-ID: <520BF3E3.5030006@gmail.com>
Date: Wed, 14 Aug 2013 17:17:23 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Tang Chen <imtangchen@gmail.com>, Tang Chen <tangchen@cn.fujitsu.com>,
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
Subject: Re: [PATCH part5 0/7] Arrange hotpluggable memory as ZONE_MOVABLE.
References: <20130812154623.GL15892@htj.dyndns.org> <52090AF6.6020206@gmail.com> <20130812162247.GM15892@htj.dyndns.org> <520914D5.7080501@gmail.com> <20130812180758.GA8288@mtj.dyndns.org> <520BC950.1030806@gmail.com> <20130814182342.GG28628@htj.dyndns.org> <520BDD2F.2060909@gmail.com> <20130814195541.GH28628@htj.dyndns.org> <520BE891.8090004@gmail.com> <20130814203538.GK28628@htj.dyndns.org>
In-Reply-To: <20130814203538.GK28628@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(8/14/13 4:35 PM), Tejun Heo wrote:
> On Wed, Aug 14, 2013 at 04:29:05PM -0400, KOSAKI Motohiro wrote:
>> Because boot failure have no chance to overlook and better way for practice.
>
> That's an extremely poor excuse.  We favor WARNs over BUGs for good
> reasons.  If a sysadmin cares about hotplug and can't deal with the
> system successfully booting, it's *trivial* to make the system behave
> in a way which has no chance of being overlooked.  What's next?
> Panicking if somebody echoes invalid value to an important knob file?
> We sure don't want that to be overlooked either, right?
>
> This discussion is so dumb.  Please stop.

You haven't explain practical benefit of your opinion. As far as users have
no benefit, I'm never agree. Sorry.

