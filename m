Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815AbaEESZw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 14:25:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22634 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbaEESZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 14:25:51 -0400
Date: Mon, 5 May 2014 20:25:32 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] perf tools: Patchset for perf sched.
Message-ID: <20140505182532.GB28367@krava.brq.redhat.com>
References: <cover.1399273302.git.yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1399273302.git.yangds.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2014 at 04:05:52PM +0900, Dongsheng Yang wrote:
> Hi Jiri,
> 	This patchset includes three patches for perf sched.
> Please help to review. :)
> 
> Dongsheng (3):
>   perf tools: add missing event for perf sched record.
>   perf tools: Adapt the TASK_STATE_TO_CHAR_STR to new value in kernel
>     space.
>   perf tools: Clarify the output of perf sched map.
hi,
looks good.. let's see if there's some feedback for 3/3

thanks,
jirka
