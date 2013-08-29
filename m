Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab3H2BcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 21:32:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61369 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752414Ab3H2BcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 21:32:16 -0400
X-IronPort-AV: E=Sophos;i="4.89,979,1367942400"; 
   d="scan'208";a="8337870"
Message-ID: <521EA44E.1020205@cn.fujitsu.com>
Date: Thu, 29 Aug 2013 09:30:54 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: rjw@sisk.pl, lenb@kernel.org, tglx@linutronix.de, mingo@elte.hu,
        hpa@zytor.com, akpm@linux-foundation.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com,
        zhangyanfei@cn.fujitsu.com, x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 00/11] x86, memblock: Allocate memory near kernel image
 before SRAT parsed.
References: <1377596268-31552-1-git-send-email-tangchen@cn.fujitsu.com> <20130828151909.GE9295@htj.dyndns.org>
In-Reply-To: <20130828151909.GE9295@htj.dyndns.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/29 09:30:12,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/29 09:30:14,
	Serialize complete at 2013/08/29 09:30:14
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2013 11:19 PM, Tejun Heo wrote:
......
> Doesn't apply to -master, -next or tip.  Again, can you please include
> which tree and git commit the patches are against in the patch
> description?  How is one supposed to know on top of which tree you're
> working?  It is in your benefit to make things easier for the prosepct
> reviewers.  Trying to guess and apply the patches to different devel
> branches and failing isn't productive and frustates your prospect
> reviewers who would of course have negative pre-perception going into
> the review and this isn't the first time this issue was raised either.
>

Hi tj,

Sorry for the trouble. Please refer to the following branch:

https://github.com/imtangchen/linux.git  movablenode-boot-option

Thanks.

