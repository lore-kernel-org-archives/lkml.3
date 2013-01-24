Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab3AXAfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 19:35:31 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:49363 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab3AXAfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 19:35:25 -0500
Message-ID: <1358987715.3351.3.camel@kernel>
Subject: Re: [PATCH Bug fix 0/5] Bug fix for physical memory hot-remove.
From: Simon Jeons <simon.jeons@gmail.com>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: akpm@linux-foundation.org, rientjes@google.com, len.brown@intel.com,
        benh@kernel.crashing.org, paulus@samba.org, cl@linux.com,
        minchan.kim@gmail.com, kosaki.motohiro@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, wujianguo@huawei.com,
        wency@cn.fujitsu.com, hpa@zytor.com, linfeng@cn.fujitsu.com,
        laijs@cn.fujitsu.com, mgorman@suse.de, yinghai@kernel.org,
        glommer@parallels.com, jiang.liu@huawei.com, julian.calaby@gmail.com,
        sfr@canb.auug.org.au, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-acpi@vger.kernel.org
Date: Wed, 23 Jan 2013 18:35:15 -0600
In-Reply-To: <50FFE2FC.9030401@cn.fujitsu.com>
References: <1358854984-6073-1-git-send-email-tangchen@cn.fujitsu.com>
	 <1358944171.3351.1.camel@kernel> <50FFE2FC.9030401@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-23 at 21:17 +0800, Tang Chen wrote:
> On 01/23/2013 08:29 PM, Simon Jeons wrote:
> > Hi Tang,
> >
> > I remember your big physical memory hot-remove patchset has already
> > merged by Andrew, but where I can find it? Could you give me git tree
> > address?
> 
> Hi Simon,
> 
> You can find all the physical memory hot-remove patches and related bugfix
> patches from the following url:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git akpm

~/linux-next$ git remote -v
origin git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
(fetch)
origin git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
(push)
~/linux-next$ git branch
* akpm
  master
~/linux-next$ wc -l mm/memory_hotplug.c 
1173 mm/memory_hotplug.c

I still can't find it. :(

> 
> 
> Thanks. :)
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>


