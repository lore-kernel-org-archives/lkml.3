Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab3IXPdH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 11:33:07 -0400
Received: from mail-yh0-f45.google.com ([209.85.213.45]:51646 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab3IXPdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 11:33:05 -0400
Date: Tue, 24 Sep 2013 11:32:59 -0400
From: Tejun Heo <tj@kernel.org>
To: Zhang Yanfei <zhangyanfei.yes@gmail.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>, lenb@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, mingo@elte.hu,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Toshi Kani <toshi.kani@hp.com>, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Thomas Renninger <trenn@suse.de>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>, Wen Congyang <wency@cn.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>, mina86@mina86.com,
        gong.chen@linux.intel.com, vasilis.liaskovitis@profitbricks.com,
        lwoodman@redhat.com, Rik van Riel <riel@redhat.com>,
        jweiner@redhat.com, prarit@redhat.com,
        "x86@kernel.org" <x86@kernel.org>, linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, linux-acpi@vger.kernel.org,
        imtangchen@gmail.com
Subject: Re: [PATCH 6/6] mem-hotplug: Introduce movablenode boot option
Message-ID: <20130924153259.GM2366@htj.dyndns.org>
References: <524162DA.30004@cn.fujitsu.com>
 <5241655E.1000007@cn.fujitsu.com>
 <20130924124121.GG2366@htj.dyndns.org>
 <5241944B.4050103@gmail.com>
 <5241AEC0.6040505@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5241AEC0.6040505@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Sep 24, 2013 at 11:24:48PM +0800, Zhang Yanfei wrote:
> I am now preparing the v5 version. Only in this patch we haven't come to an
> agreement. So as for the boot option name, after my explanation, do you still
> have the objection? Or you could suggest a good name for us, that'll be
> very thankful:)

No particular idea and my concern about the name isn't very strong.
It just doesn't seem like a good name to me.  It's a bit obscure and
we may want to do more things for hotplug later which may not fit the
param name.  If you guys think it's good enough, please go ahead.

Thanks.

-- 
tejun
