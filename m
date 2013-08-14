Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760286Ab3HNUfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 16:35:46 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:36155 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760173Ab3HNUfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 16:35:44 -0400
Date: Wed, 14 Aug 2013 16:35:38 -0400
From: Tejun Heo <tj@kernel.org>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Tang Chen <imtangchen@gmail.com>, Tang Chen <tangchen@cn.fujitsu.com>,
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
Message-ID: <20130814203538.GK28628@htj.dyndns.org>
References: <20130812154623.GL15892@htj.dyndns.org>
 <52090AF6.6020206@gmail.com>
 <20130812162247.GM15892@htj.dyndns.org>
 <520914D5.7080501@gmail.com>
 <20130812180758.GA8288@mtj.dyndns.org>
 <520BC950.1030806@gmail.com>
 <20130814182342.GG28628@htj.dyndns.org>
 <520BDD2F.2060909@gmail.com>
 <20130814195541.GH28628@htj.dyndns.org>
 <520BE891.8090004@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520BE891.8090004@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 04:29:05PM -0400, KOSAKI Motohiro wrote:
> Because boot failure have no chance to overlook and better way for practice.

That's an extremely poor excuse.  We favor WARNs over BUGs for good
reasons.  If a sysadmin cares about hotplug and can't deal with the
system successfully booting, it's *trivial* to make the system behave
in a way which has no chance of being overlooked.  What's next?
Panicking if somebody echoes invalid value to an important knob file?
We sure don't want that to be overlooked either, right?

This discussion is so dumb.  Please stop.

Thanks.

-- 
tejun
