Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030517Ab3FUG0i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 02:26:38 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:48544 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965335Ab3FUG0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 02:26:36 -0400
Date: Thu, 20 Jun 2013 23:26:31 -0700
From: Tejun Heo <tj@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de, mingo@elte.hu,
        akpm@linux-foundation.org, trenn@suse.de, yinghai@kernel.org,
        jiang.liu@huawei.com, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Toshi Kani <toshi.kani@hp.com>
Subject: Re: [Part1 PATCH v5 00/22] x86, ACPI, numa: Parse numa info earlier
Message-ID: <20130621062631.GA11014@mtj.dyndns.org>
References: <1371128589-8953-1-git-send-email-tangchen@cn.fujitsu.com>
 <51C3E276.8030804@zytor.com>
 <51C3ED76.3040900@cn.fujitsu.com>
 <51C3EE54.4060707@zytor.com>
 <51C3F0AC.5020006@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C3F0AC.5020006@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, guys.

On Fri, Jun 21, 2013 at 02:20:28PM +0800, Tang Chen wrote:
> >What about Tejun's feedback?
> 
> tj's comments were after the latest version. So we need to
> restructure the patch-set.

Given that it's unlikely to reach actual functionality in this cycle,
it's probably a better idea to aim the next cycle.  I don't think we
wanna rush it.  As for my suggestions, I'm not sure how much of it'd
work out and how much better it's gonna make things but it definitely
seems worth investigating to me.  Let's please see how it goes.

Thanks a lot!

-- 
tejun
