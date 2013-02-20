Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935554Ab3BTDAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 22:00:44 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:41529 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933835Ab3BTDAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 22:00:43 -0500
X-IronPort-AV: E=Sophos;i="4.84,699,1355068800"; 
   d="scan'208";a="6732431"
Message-ID: <51243BF7.3030004@cn.fujitsu.com>
Date: Wed, 20 Feb 2013 10:59:03 +0800
From: Lin Feng <linfeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
CC: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        bcrl@kvack.org, viro@zeniv.linux.org.uk, khlebnikov@openvz.org,
        walken@google.com, kamezawa.hiroyu@jp.fujitsu.com, minchan@kernel.org,
        riel@redhat.com, rientjes@google.com, isimatu.yasuaki@jp.fujitsu.com,
        wency@cn.fujitsu.com, laijs@cn.fujitsu.com, jiang.liu@huawei.com,
        mhocko@suse.cz, linux-mm@kvack.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: hotplug: implement non-movable version of get_user_pages()
 called get_user_pages_non_movable()
References: <1359972248-8722-1-git-send-email-linfeng@cn.fujitsu.com> <1359972248-8722-2-git-send-email-linfeng@cn.fujitsu.com> <20130204160624.5c20a8a0.akpm@linux-foundation.org> <20130205115722.GF21389@suse.de> <20130205133244.GH21389@suse.de> <51238033.6010005@cn.fujitsu.com> <5124363C.9060604@cn.fujitsu.com> <20130220024435.GA30208@hacker.(null)>
In-Reply-To: <20130220024435.GA30208@hacker.(null)>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/20 10:59:57,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/20 11:00:01,
	Serialize complete at 2013/02/20 11:00:01
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wanpeng,

On 02/20/2013 10:44 AM, Wanpeng Li wrote:
>> Sorry, I misunderstood what "tail pages" means, stupid question, just ignore it.
>> >flee...
> According to the compound page, the first page of compound page is
> called head page, other sub pages are called tail pages.
> 
> Regards,
> Wanpeng Li 
> 
Yes, you are right, thanks for explaining.
I thought it just means only the last one of the compound pages..

thanks,
linfeng
