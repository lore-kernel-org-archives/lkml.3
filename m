Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935451Ab3BTCgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 21:36:15 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:44064 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S934420Ab3BTCgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 21:36:14 -0500
X-IronPort-AV: E=Sophos;i="4.84,699,1355068800"; 
   d="scan'208";a="6732269"
Message-ID: <5124363C.9060604@cn.fujitsu.com>
Date: Wed, 20 Feb 2013 10:34:36 +0800
From: Lin Feng <linfeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, bcrl@kvack.org,
        viro@zeniv.linux.org.uk, khlebnikov@openvz.org, walken@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, minchan@kernel.org, riel@redhat.com,
        rientjes@google.com, isimatu.yasuaki@jp.fujitsu.com,
        wency@cn.fujitsu.com, laijs@cn.fujitsu.com, jiang.liu@huawei.com,
        mhocko@suse.cz, linux-mm@kvack.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: hotplug: implement non-movable version of get_user_pages()
 called get_user_pages_non_movable()
References: <1359972248-8722-1-git-send-email-linfeng@cn.fujitsu.com> <1359972248-8722-2-git-send-email-linfeng@cn.fujitsu.com> <20130204160624.5c20a8a0.akpm@linux-foundation.org> <20130205115722.GF21389@suse.de> <20130205133244.GH21389@suse.de> <51238033.6010005@cn.fujitsu.com>
In-Reply-To: <51238033.6010005@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/20 10:35:31,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/20 10:35:32,
	Serialize complete at 2013/02/20 10:35:32
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/19/2013 09:37 PM, Lin Feng wrote:
>> > 
>> > The other is that this almost certainly broken for transhuge page
>> > handling. gup returns the head and tail pages and ordinarily this is ok
> I can't find codes doing such things :(, could you please point me out?
> 
Sorry, I misunderstood what "tail pages" means, stupid question, just ignore it.
flee...

thanks,
linfeng
