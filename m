Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751414AbaBNJzO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 04:55:14 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:9443 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750932AbaBNJzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 04:55:11 -0500
X-IronPort-AV: E=Sophos;i="4.95,843,1384272000"; 
   d="scan'208";a="9527370"
Message-ID: <52FDE7C5.5000401@cn.fujitsu.com>
Date: Fri, 14 Feb 2014 17:54:13 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 0/9] Add MAX_NICE, MIN_NICE and NICE_WIDTH macros in prio.h.
References: <cover.1392103744.git.yangds.fnst@cn.fujitsu.com> <52FDE06A.1020909@cn.fujitsu.com> <20140214095143.GH27965@twins.programming.kicks-ass.net>
In-Reply-To: <20140214095143.GH27965@twins.programming.kicks-ass.net>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/14 17:53:02,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/14 17:53:07,
	Serialize complete at 2014/02/14 17:53:07
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2014 05:51 PM, Peter Zijlstra wrote:
> On Fri, Feb 14, 2014 at 05:22:50PM +0800, Dongsheng Yang wrote:
>> Hi Ingo & Peter,
>>      What's your opinion on this patchset?
> I queued it; I wasn't convinced but people seem to like it, which is
> good enough.

Thank you :)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

