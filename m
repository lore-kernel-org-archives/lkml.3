Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935285Ab3BTMkl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 07:40:41 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60747 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932945Ab3BTMkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 07:40:40 -0500
X-IronPort-AV: E=Sophos;i="4.84,702,1355068800"; 
   d="scan'208";a="6736913"
Message-ID: <5124C3E6.1060108@cn.fujitsu.com>
Date: Wed, 20 Feb 2013 20:39:02 +0800
From: Lin Feng <linfeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
CC: akpm@linux-foundation.org, mgorman@suse.de, bcrl@kvack.org,
        viro@zeniv.linux.org.uk, khlebnikov@openvz.org, walken@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, minchan@kernel.org, riel@redhat.com,
        rientjes@google.com, isimatu.yasuaki@jp.fujitsu.com,
        wency@cn.fujitsu.com, laijs@cn.fujitsu.com, jiang.liu@huawei.com,
        zab@redhat.com, jmoyer@redhat.com, linux-mm@kvack.org,
        linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/2] mm: hotplug: implement non-movable version of
 get_user_pages() called get_user_pages_non_movable()
References: <1360056113-14294-1-git-send-email-linfeng@cn.fujitsu.com> <1360056113-14294-2-git-send-email-linfeng@cn.fujitsu.com> <20130220113757.GA10124@hacker.(null)>
In-Reply-To: <20130220113757.GA10124@hacker.(null)>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/20 20:39:56,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/20 20:39:57,
	Serialize complete at 2013/02/20 20:39:57
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi  Wanpeng,

On 02/20/2013 07:37 PM, Wanpeng Li wrote:
>> + * This function first calls get_user_pages() to get the candidate pages, and
>> >+ * then check to ensure all pages are from non movable zone. Otherwise migrate
> How about "Otherwise migrate candidate pages which have already been 
> isolated to non movable zone."?
> 

Which is just what the code does, I'm feeling that it's too detailed to be proper :(
Do we have to comment it like that detailedly?

thanks,
linfeng
