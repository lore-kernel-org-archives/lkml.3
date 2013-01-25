Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001Ab3AYNRt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 08:17:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60212 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756161Ab3AYNRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 08:17:46 -0500
Date: Fri, 25 Jan 2013 14:17:40 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Simon Jeons <simon.jeons@gmail.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>, akpm@linux-foundation.org,
        rientjes@google.com, len.brown@intel.com, benh@kernel.crashing.org,
        paulus@samba.org, cl@linux.com, minchan.kim@gmail.com,
        kosaki.motohiro@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        wujianguo@huawei.com, wency@cn.fujitsu.com, hpa@zytor.com,
        linfeng@cn.fujitsu.com, laijs@cn.fujitsu.com, mgorman@suse.de,
        yinghai@kernel.org, glommer@parallels.com, jiang.liu@huawei.com,
        julian.calaby@gmail.com, sfr@canb.auug.org.au, x86@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH Bug fix 0/5] Bug fix for physical memory hot-remove.
Message-ID: <20130125131740.GA1615@dhcp22.suse.cz>
References: <1358854984-6073-1-git-send-email-tangchen@cn.fujitsu.com>
 <1358944171.3351.1.camel@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358944171.3351.1.camel@kernel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 23-01-13 06:29:31, Simon Jeons wrote:
> On Tue, 2013-01-22 at 19:42 +0800, Tang Chen wrote:
> > Here are some bug fix patches for physical memory hot-remove. All these
> > patches are based on the latest -mm tree.
> > git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git akpm
> > 
> > And patch1 and patch3 are very important.
> > patch1: free compound pages when freeing memmap, otherwise the kernel
> >         will panic the next time memory is hot-added.
> > patch3: the old way of freeing pagetable pages was wrong. We should never
> >         split larger pages into small ones.
> > 
> > 
> 
> Hi Tang,
> 
> I remember your big physical memory hot-remove patchset has already
> merged by Andrew, but where I can find it? Could you give me git tree 
> address?

Andrew tree is also mirrored into a git tree.
http://git.kernel.org/?p=linux/kernel/git/mhocko/mm.git;a=summary

It contains only Memory management patches on top of the last major
release (since-.X.Y branch).
-- 
Michal Hocko
SUSE Labs
