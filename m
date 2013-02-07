Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757680Ab3BGBwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 20:52:00 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:27420 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751750Ab3BGBv7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 20:51:59 -0500
X-IronPort-AV: E=Sophos;i="4.84,619,1355068800"; 
   d="scan'208";a="6697911"
Message-ID: <5113085E.4030104@cn.fujitsu.com>
Date: Thu, 07 Feb 2013 09:50:22 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Simon Horman <horms@verge.net.au>
CC: Julian Anastasov <ja@ssi.bg>, Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kamezawa.hiroyu@jp.fujitsu.com, minchan@kernel.org, mgorman@suse.de
Subject: Re: [PATCH 6/7] net: change type of netns_ipvs->sysctl_sync_qlen_max
References: <alpine.LFD.2.00.1302061115590.1664@ja.ssi.bg> <5112240C.1010105@cn.fujitsu.com> <20130207010914.GA9070@verge.net.au>
In-Reply-To: <20130207010914.GA9070@verge.net.au>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/07 09:50:38,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/07 09:50:38
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年02月07日 09:09, Simon Horman 写道:
> On Wed, Feb 06, 2013 at 05:36:12PM +0800, Zhang Yanfei wrote:
>> 于 2013年02月06日 17:29, Julian Anastasov 写道:
>>>
>>> 	Hello,
>>>
>>> 	Sorry that I'm writing a private email but I
>>> deleted your original message by mistake. Your change
>>> of the sysctl_sync_qlen_max from int to long is may be
>>> not enough.
>>>
>>> 	net/netfilter/ipvs/ip_vs_ctl.c contains
>>> proc var "sync_qlen_max" that should be changed to
>>> sizeof(unsigned long) and updated with proc_doulongvec_minmax.
>>>
>>
>> Thanks for pointing this. I will update this in patch v2.
> 
> Hi Zhang,
> 
> Thanks for helping to keep IPVS up to date.
> 
> It seems to me that include/net/ip_vs.h:sysctl_sync_qlen_max()
> and its call site, net/netfilter/ipvs/ip_vs_sync.c:sb_queue_tail()
> may also need to be updated.
> 
> Could you look at including that in v2 too?

OK. I will update it.

Thanks
Zhang

