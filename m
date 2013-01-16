Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab3APOPM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 09:15:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54003 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab3APOPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 09:15:09 -0500
Date: Wed, 16 Jan 2013 15:15:08 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Lin Feng <linfeng@cn.fujitsu.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, jbeulich@suse.com,
        dhowells@redhat.com, wency@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, paul.gortmaker@windriver.com,
        laijs@cn.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie,
        minchan@kernel.org, aquini@redhat.com, jiang.liu@huawei.com,
        tony.luck@intel.com, fenghua.yu@intel.com, benh@kernel.crashing.org,
        paulus@samba.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        davem@davemloft.net, michael@ellerman.id.au,
        gerald.schaefer@de.ibm.com, gregkh@linuxfoundation.org, x86@kernel.org,
        linux390@de.ibm.com, linux-ia64@vger.kernel.org,
        linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        tangchen@cn.fujitsu.com
Subject: Re: [PATCH v3 0/2] memory-hotplug: introduce
 CONFIG_HAVE_BOOTMEM_INFO_NODE and revert register_page_bootmem_info_node()
 when platform not support
Message-ID: <20130116141508.GF343@dhcp22.suse.cz>
References: <1358324059-9608-1-git-send-email-linfeng@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358324059-9608-1-git-send-email-linfeng@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 16-01-13 16:14:17, Lin Feng wrote:
[...]
> changeLog v2->v3:
> 1) patch 1/2:
> - Rename the patch title to conform it's content.
> - Update memory_hotplug.h and remove the misleading TODO pointed out by Michal.
> 2) patch 2/2:
> - New added, remove unimplemented functions suggested by Michal.

I think that both patches should be merged into one and put to Andrew's
queue as
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix.patch
rather than a separate patch.
-- 
Michal Hocko
SUSE Labs
