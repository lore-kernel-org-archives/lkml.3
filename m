Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab3ELPRY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 11:17:24 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:33229 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab3ELPRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 11:17:23 -0400
Message-ID: <518FB27A.4070903@gmail.com>
Date: Sun, 12 May 2013 23:17:14 +0800
From: Liu Jiang <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Cody P Schafer <cody@linux.vnet.ibm.com>
CC: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiang Liu <jiang.liu@huawei.com>, David Rientjes <rientjes@google.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        David Howells <dhowells@redhat.com>, Mark Salter <msalter@redhat.com>,
        Jianguo Wu <wujianguo@huawei.com>, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v5, part4 20/41] mm/h8300: prepare for removing num_physpages
 and simplify mem_init()
References: <1368028298-7401-1-git-send-email-jiang.liu@huawei.com> <1368028298-7401-21-git-send-email-jiang.liu@huawei.com> <518A7CC0.1010606@cogentembedded.com> <518AA7A0.1020702@cogentembedded.com> <518AE13A.2060204@linux.vnet.ibm.com>
In-Reply-To: <518AE13A.2060204@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2013 07:35 AM, Cody P Schafer wrote:
> On 05/08/2013 12:29 PM, Sergei Shtylyov wrote:
>>
>>      Although, not necessarily: it also supports CONFIG_DYNAMIC_DEBUG --
>> look at how pr_debug() is defined.
>> So this doesn't seem to be an equivalent change, and I suggest not doing
>> it at all.
>>
>> WBR, Sergei
>
> pr_devel() should get the same behavior: no code emitted unless debug 
> is defined, if it is, output at KERN_DEBUG level.
>
Thanks Cody and Sergei, will use pr_devel() instead in next version.
Gerry
