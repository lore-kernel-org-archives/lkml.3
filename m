Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab3AWOAJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 09:00:09 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62919 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755405Ab3AWOAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 09:00:07 -0500
X-IronPort-AV: E=Sophos;i="4.84,523,1355068800"; 
   d="scan'208";a="6635898"
Message-ID: <50FFE2FC.9030401@cn.fujitsu.com>
Date: Wed, 23 Jan 2013 21:17:48 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Simon Jeons <simon.jeons@gmail.com>
CC: akpm@linux-foundation.org, rientjes@google.com, len.brown@intel.com,
        benh@kernel.crashing.org, paulus@samba.org, cl@linux.com,
        minchan.kim@gmail.com, kosaki.motohiro@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, wujianguo@huawei.com,
        wency@cn.fujitsu.com, hpa@zytor.com, linfeng@cn.fujitsu.com,
        laijs@cn.fujitsu.com, mgorman@suse.de, yinghai@kernel.org,
        glommer@parallels.com, jiang.liu@huawei.com, julian.calaby@gmail.com,
        sfr@canb.auug.org.au, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH Bug fix 0/5] Bug fix for physical memory hot-remove.
References: <1358854984-6073-1-git-send-email-tangchen@cn.fujitsu.com> <1358944171.3351.1.camel@kernel>
In-Reply-To: <1358944171.3351.1.camel@kernel>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/23 21:17:41,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/23 21:17:51,
	Serialize complete at 2013/01/23 21:17:51
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2013 08:29 PM, Simon Jeons wrote:
> Hi Tang,
>
> I remember your big physical memory hot-remove patchset has already
> merged by Andrew, but where I can find it? Could you give me git tree
> address?

Hi Simon,

You can find all the physical memory hot-remove patches and related bugfix
patches from the following url:

git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git akpm


Thanks. :)

