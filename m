Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab3EHXfh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 19:35:37 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:37290 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752748Ab3EHXfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 19:35:34 -0400
Message-ID: <518AE13A.2060204@linux.vnet.ibm.com>
Date: Wed, 08 May 2013 16:35:22 -0700
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: Jiang Liu <liuj97@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
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
References: <1368028298-7401-1-git-send-email-jiang.liu@huawei.com> <1368028298-7401-21-git-send-email-jiang.liu@huawei.com> <518A7CC0.1010606@cogentembedded.com> <518AA7A0.1020702@cogentembedded.com>
In-Reply-To: <518AA7A0.1020702@cogentembedded.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050823-9360-0000-0000-00001217E708
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2013 12:29 PM, Sergei Shtylyov wrote:
>
>      Although, not necessarily: it also supports CONFIG_DYNAMIC_DEBUG --
> look at how pr_debug() is defined.
> So this doesn't seem to be an equivalent change, and I suggest not doing
> it at all.
>
> WBR, Sergei

pr_devel() should get the same behavior: no code emitted unless debug is 
defined, if it is, output at KERN_DEBUG level.

