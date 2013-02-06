Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150Ab3BFKK6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 05:10:58 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:15894 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754908Ab3BFKKz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:10:55 -0500
X-IronPort-AV: E=Sophos;i="4.84,614,1355068800"; 
   d="scan'208";a="6696524"
Message-ID: <5112240C.1010105@cn.fujitsu.com>
Date: Wed, 06 Feb 2013 17:36:12 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Julian Anastasov <ja@ssi.bg>
CC: Andrew Morton <akpm@linux-foundation.org>, horms@verge.net.au,
        Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kamezawa.hiroyu@jp.fujitsu.com, minchan@kernel.org, mgorman@suse.de
Subject: Re: [PATCH 6/7] net: change type of netns_ipvs->sysctl_sync_qlen_max
References: <alpine.LFD.2.00.1302061115590.1664@ja.ssi.bg>
In-Reply-To: <alpine.LFD.2.00.1302061115590.1664@ja.ssi.bg>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/06 17:36:28,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/06 17:36:52
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年02月06日 17:29, Julian Anastasov 写道:
> 
> 	Hello,
> 
> 	Sorry that I'm writing a private email but I
> deleted your original message by mistake. Your change
> of the sysctl_sync_qlen_max from int to long is may be
> not enough.
> 
> 	net/netfilter/ipvs/ip_vs_ctl.c contains
> proc var "sync_qlen_max" that should be changed to
> sizeof(unsigned long) and updated with proc_doulongvec_minmax.
> 

Thanks for pointing this. I will update this in patch v2.

Thanks
Zhang Yanfei


