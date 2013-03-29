Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987Ab3C2QRf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 12:17:35 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:53148 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021Ab3C2QRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 12:17:33 -0400
Date: Fri, 29 Mar 2013 17:17:31 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        David Howells <dhowells@redhat.com>, Mark Salter <msalter@redhat.com>,
        Jianguo Wu <wujianguo@huawei.com>, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>, sparclinux@vger.kernel.org
Subject: Re: [PATCH v3, part4 32/39] mm/SPARC: prepare for removing
	num_physpages and simplify mem_init()
Message-ID: <20130329161731.GB6201@merkur.ravnborg.org>
References: <1364313298-17336-1-git-send-email-jiang.liu@huawei.com> <1364313298-17336-33-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364313298-17336-33-git-send-email-jiang.liu@huawei.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 11:54:51PM +0800, Jiang Liu wrote:
> Prepare for removing num_physpages and simplify mem_init().
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Cc: Tang Chen <tangchen@cn.fujitsu.com>
> Cc: sparclinux@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org

Looks good!
Acked-by: Sam Ravnborg <sam@ravnborg.org>

	Sam
