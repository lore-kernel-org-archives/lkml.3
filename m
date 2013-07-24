Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab3GXPzP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 11:55:15 -0400
Received: from mail-gh0-f182.google.com ([209.85.160.182]:44376 "EHLO
	mail-gh0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab3GXPzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 11:55:09 -0400
Date: Wed, 24 Jul 2013 11:54:58 -0400
From: Tejun Heo <tj@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
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
Subject: Re: [PATCH 02/21] memblock, numa: Introduce flag into memblock.
Message-ID: <20130724155458.GA20377@mtj.dyndns.org>
References: <1374220774-29974-1-git-send-email-tangchen@cn.fujitsu.com>
 <1374220774-29974-3-git-send-email-tangchen@cn.fujitsu.com>
 <20130723190928.GH21100@mtj.dyndns.org>
 <51EF4196.8050303@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51EF4196.8050303@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 10:53:10AM +0800, Tang Chen wrote:
> >Let's please drop "with" and do we really need to print full 16
> >digits?
> 
> Sure, will remove "with". But I think printing out the full flags is batter.
> The output seems more tidy.

I mean, padding is fine but you can just print out 4 or even 2 digits
and will be fine for the foreseeable future.

-- 
tejun
