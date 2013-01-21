Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab3AUBv2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 20:51:28 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:31292 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752497Ab3AUBv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 20:51:27 -0500
X-IronPort-AV: E=Sophos;i="4.84,503,1355068800"; 
   d="scan'208";a="6617621"
Message-ID: <50FC9EDB.7060105@cn.fujitsu.com>
Date: Mon, 21 Jan 2013 09:50:19 +0800
From: Lin Feng <linfeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memory-hotplug: mm/Kconfig: move auto selects from MEMORY_HOTPLUG
 to MEMORY_HOTREMOVE as needed
References: <1358495676-4488-1-git-send-email-linfeng@cn.fujitsu.com> <20130118135828.GD10701@dhcp22.suse.cz>
In-Reply-To: <20130118135828.GD10701@dhcp22.suse.cz>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/21 09:50:33,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/21 09:50:33,
	Serialize complete at 2013/01/21 09:50:33
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On 01/18/2013 09:58 PM, Michal Hocko wrote:
> On Fri 18-01-13 15:54:36, Lin Feng wrote:
>> Besides page_isolation.c selected by MEMORY_ISOLATION under MEMORY_HOTPLUG
>> is also such case, move it too.
> 
> Yes, it seems that only HOTREMOVE needs MEMORY_ISOLATION but that should
> be done in a separate patch as this change is already upstream and
> should be merged separately. It would also be nice to mention which
I didn't notice such rules before, I will take care next time :)

> functions are we talking about. AFAICS:
> alloc_migrate_target, test_pages_isolated, start_isolate_page_range and
> undo_isolate_page_range.
> 
Anyway, thanks all your good suggestions for the fixes in this series.

thanks again,
linfeng 
