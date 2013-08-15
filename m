Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760008Ab3HOBoZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 21:44:25 -0400
Received: from mail-qe0-f45.google.com ([209.85.128.45]:34470 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758372Ab3HOBoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 21:44:23 -0400
Message-ID: <520C3273.10605@gmail.com>
Date: Wed, 14 Aug 2013 21:44:19 -0400
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
References: <520BC950.1030806@gmail.com> <20130814182342.GG28628@htj.dyndns.org> <520BDD2F.2060909@gmail.com> <20130814195541.GH28628@htj.dyndns.org> <520BE891.8090004@gmail.com> <20130814203538.GK28628@htj.dyndns.org> <520BF3E3.5030006@gmail.com> <20130814213637.GO28628@htj.dyndns.org> <520C2A06.5020007@gmail.com> <20130815012133.GQ28628@htj.dyndns.org> <20130815013346.GR28628@htj.dyndns.org>
In-Reply-To: <20130815013346.GR28628@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(8/14/13 9:33 PM), Tejun Heo wrote:
> On Wed, Aug 14, 2013 at 09:21:33PM -0400, Tejun Heo wrote:
>>> Secondly, memory hotplug is now maintained I and kamezawa-san. Then, I much likely
>>> have a chance to get a hotplug related bug report. For protecting my life, I don't
>>> want get a false bug claim. Then, I wouldn't like to aim incomplete fallback. When
>>> an admin makes mistake, they should shoot their foot, not me!
>>
>> Dude, it's not cool to cause users' machine to fail boot because you
>> want bug report.  You don't do that.  There are other ways to achieve
>> that.  When the kernel can't make all hotpluggable nodes hotpluggable
>> (I mean, it's not necessarily node aligned to begin with), generate
>> warning and a debug dump with appropriate log levels.
>>
>> If you think causing users' machine fail boot indetermistically is
>> acceptable, you really shouldn't be maintaining anything.  What is
>> this?  Are you nuts?
>
> This is doubly idiotic because this is all early boot.  Most users
> don't even have a way to access the debug info if the machine crashes
> that early.  Developement convenience is something that we consider
> too but, seriously, users come first.  This is not your personal
> playground.  Don't frigging crash if you have any other option.

Again, the best depend on the purpose and the goal. If someone specify
to enable hotplugging, They are sure they need it. Now, any fallback
achieve their goal. Their goal is not booting. If they don't have enough
machine to achieve their goal, we have only one way, tell them that.
If we had an alternative way, I might say an another answer.
