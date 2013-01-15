Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671Ab3AOK2I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 05:28:08 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:48302 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755667Ab3AOK2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 05:28:07 -0500
X-IronPort-AV: E=Sophos;i="4.84,473,1355068800"; 
   d="scan'208";a="6591206"
Message-ID: <50F52EF8.7050605@cn.fujitsu.com>
Date: Tue, 15 Jan 2013 18:27:04 +0800
From: Lin Feng <linfeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: akpm@linux-foundation.org, linux-mm@kvack.org, wency@cn.fujitsu.com,
        jiang.liu@huawei.com, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        tangchen@cn.fujitsu.com
Subject: Re: [PATCH] memory-hotplug: revert register_page_bootmem_info_node()
 to empty when platform related code is not implemented
References: <1358160835-30617-1-git-send-email-linfeng@cn.fujitsu.com> <20130114184308.GD5126@dhcp22.suse.cz>
In-Reply-To: <20130114184308.GD5126@dhcp22.suse.cz>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/15 18:27:21,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/15 18:27:22,
	Serialize complete at 2013/01/15 18:27:22
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

I have updated to V2 version according to what you said, would you please take a look 
if it conforms to what you think? 

thanks,
linfeng

On 01/15/2013 02:43 AM, Michal Hocko wrote:
> This is just ugly. Could you please add something like HAVE_BOOTMEM_INFO_NODE
> or something with a bettern name and let CONFIG_MEMORY_HOTPLUG select it
> for supported architectures and configurations (e.g.
> CONFIG_SPARSEMEM_VMEMMAP doesn't need a special arch support, right?).
> These Todo things are just too messy.
> -- 
