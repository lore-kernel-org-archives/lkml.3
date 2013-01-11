Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab3AKLzm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 06:55:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58111 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754120Ab3AKLzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 06:55:40 -0500
Date: Fri, 11 Jan 2013 12:55:37 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Lin Feng <linfeng@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>, Wu Jianguo <wujianguo@huawei.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: mmots: memory-hotplug: implement
 register_page_bootmem_info_section of sparse-vmemmap fix
Message-ID: <20130111115537.GH7286@dhcp22.suse.cz>
References: <20130111095658.GC7286@dhcp22.suse.cz>
 <20130111101745.GD7286@dhcp22.suse.cz>
 <20130111102924.GE7286@dhcp22.suse.cz>
 <20130111104759.GF7286@dhcp22.suse.cz>
 <50EFF2CB.8060206@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50EFF2CB.8060206@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 11-01-13 19:08:59, Lin Feng wrote:
> Hi Michal,
> 
> On 01/11/2013 06:47 PM, Michal Hocko wrote:
> > Signed-off-by: Michal Hocko <mhocko@suse.cz>
> > ---
> >  arch/x86/mm/init_64.c |    3 +++
> >  include/linux/mm.h    |    2 ++
> >  2 files changed, 5 insertions(+)
> > 
> > diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> > index ddd3b58..d8edf52 100644
> > --- a/arch/x86/mm/init_64.c
> > +++ b/arch/x86/mm/init_64.c
> > @@ -32,6 +32,7 @@
> >  #include <linux/memory_hotplug.h>
> linux/memory_hotplug.h has already been included here.

Ohh, I have missed that.
-- 
Michal Hocko
SUSE Labs
