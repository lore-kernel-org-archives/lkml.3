Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbaCTCEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 22:04:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59311 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbaCTCE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 22:04:28 -0400
X-IronPort-AV: E=Sophos;i="4.97,690,1389715200"; 
   d="scan'208";a="9731469"
Message-ID: <532A4C35.4090202@cn.fujitsu.com>
Date: Thu, 20 Mar 2014 10:02:29 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, joe@perches.com, mingo@kernel.org,
        tglx@linutronix.de, heiko.carstens@de.ibm.com
Subject: Re: [PATCH 00/17 for-tip V3] A series patches about sched priority.
References: <cover.1394532288.git.yangds.fnst@cn.fujitsu.com> <20140319083644.GL22095@laptop.programming.kicks-ass.net>
In-Reply-To: <20140319083644.GL22095@laptop.programming.kicks-ass.net>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/20 10:01:28,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/20 10:01:30,
	Serialize complete at 2014/03/20 10:01:30
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2014 04:36 PM, Peter Zijlstra wrote:
> I picked up all except:
>
>   2 - whcih I don't think should go through a scheduler tree

Peter, as you did not pick the patch 2, there will be a conflict when you
apply [3/17]. I sent a v2 for [3/17], which does not depend to [2/17].

Please replace [3/17] with the V2 one.

Thanx.
>   6 - its tools/ bits, the changelog wasn't clear if the MIN/MAX_NICE
>        macros were uapi visible and I couldn't be bothered to figure it out.
>   8 - I don't like the pointless macro
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

