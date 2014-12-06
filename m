Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447AbaLFM4Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 07:56:25 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:49802 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbaLFM4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 07:56:23 -0500
Date: Sat, 6 Dec 2014 07:56:17 -0500
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        "\\\"Rafael J. Wysocki\\\"" <rjw@rjwysocki.net>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Oleg Nesterov <oleg@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-pm@vger.kernel.org
Subject: Re: [PATCH -v2 1/5] oom: add helpers for setting and clearing
 TIF_MEMDIE
Message-ID: <20141206125617.GB18711@htj.dyndns.org>
References: <20141110163055.GC18373@dhcp22.suse.cz>
 <1417797707-31699-1-git-send-email-mhocko@suse.cz>
 <1417797707-31699-2-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417797707-31699-2-git-send-email-mhocko@suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 05:41:43PM +0100, Michal Hocko wrote:
> +/**
> + * Marks the given taks as OOM victim.

/**
 * $FUNCTION_NAME - $DESCRIPTION

> + * @tsk: task to mark
> + */
> +void mark_tsk_oom_victim(struct task_struct *tsk)
> +{
> +	set_tsk_thread_flag(tsk, TIF_MEMDIE);
> +}
> +
> +/**
> + * Unmarks the current task as OOM victim.

Ditto.

-- 
tejun
