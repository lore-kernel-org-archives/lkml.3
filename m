Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933199Ab3HNU2u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 16:28:50 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:57999 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933026Ab3HNU2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 16:28:48 -0400
Message-ID: <520BE891.8090004@gmail.com>
Date: Wed, 14 Aug 2013 16:29:05 -0400
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
References: <20130812145016.GI15892@htj.dyndns.org> <52090225.6070208@gmail.com> <20130812154623.GL15892@htj.dyndns.org> <52090AF6.6020206@gmail.com> <20130812162247.GM15892@htj.dyndns.org> <520914D5.7080501@gmail.com> <20130812180758.GA8288@mtj.dyndns.org> <520BC950.1030806@gmail.com> <20130814182342.GG28628@htj.dyndns.org> <520BDD2F.2060909@gmail.com> <20130814195541.GH28628@htj.dyndns.org>
In-Reply-To: <20130814195541.GH28628@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(8/14/13 3:55 PM), Tejun Heo wrote:
> Hello,
>
> On Wed, Aug 14, 2013 at 03:40:31PM -0400, KOSAKI Motohiro wrote:
>> I don't agree it. Please look at other kernel options. A lot of these don't
>> follow you. These behave as direction, not advise.
>>
>> I mean the fallback should be implemented at turning on default the feature.
>
> Yeah, some options are "please try this" and others "do this or fail".
> There's no frigging fundamental rule there.

In this case, we have zero worth for fallback, right?


>> I don't read whole discussion and I don't quite understand why no kernel
>> place controlling is relevant. Every unpluggable node is suitable for
>> kernel. If you mean current kernel placement logic don't care plugging,
>> that's a bug.
>>
>> If we aim to hot remove, we have to have either kernel relocation or
>> hotplug awre kernel placement at boot time.
>
> What if all nodes are hot pluggable?  Are we moving the kernel
> dynamically then?

Intel folks already told, we have no such system in practice.


>>> Failing to boot is *way* worse reporting mechanism than almost
>>> everything else.  If the sysadmin is willing to risk machines failing
>>> to come up, she would definitely be willing to check whether which
>>> memory areas are actually hotpluggable too, right?
>>
>> No. see above. Your opinion is not pragmatic useful.
>
> No, what you're saying doesn't make any sense.  There are multiple
> ways to report when something doesn't work.  Failing to boot is *one*
> of them and not a very good one.  Here, for practical reasons, the end
> result may differ depending on the specifics of the configuration, so
> more detailed reporting is necessary anyway, so why do you insist on
> failing the boot?  In what world is it a good thing for the machine to
> fail boot after bios or kernel update?

Because boot failure have no chance to overlook and better way for practice.



