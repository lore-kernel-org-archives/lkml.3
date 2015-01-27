Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932589AbbA0RAH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 12:00:07 -0500
Received: from resqmta-po-04v.sys.comcast.net ([96.114.154.163]:36936 "EHLO
	resqmta-po-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932346AbbA0RAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 12:00:02 -0500
Date: Tue, 27 Jan 2015 10:59:59 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Michal Hocko <mhocko@suse.cz>
cc: Vinayak Menon <vinmenon@codeaurora.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        hannes@cmpxchg.org, vdavydov@parallels.com, mgorman@suse.de,
        minchan@kernel.org
Subject: Re: [PATCH v2] mm: vmscan: fix the page state calculation in
 too_many_isolated
In-Reply-To: <20150127105242.GC19880@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.11.1501271058230.25124@gentwo.org>
References: <20150114165036.GI4706@dhcp22.suse.cz> <54B7F7C4.2070105@codeaurora.org> <20150116154922.GB4650@dhcp22.suse.cz> <54BA7D3A.40100@codeaurora.org> <alpine.DEB.2.11.1501171347290.25464@gentwo.org> <54BC879C.90505@codeaurora.org>
 <20150121143920.GD23700@dhcp22.suse.cz> <alpine.DEB.2.11.1501221010510.3937@gentwo.org> <20150126174606.GD22681@dhcp22.suse.cz> <alpine.DEB.2.11.1501261233550.16786@gentwo.org> <20150127105242.GC19880@dhcp22.suse.cz>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2015, Michal Hocko wrote:

> I am not following. The idea was to run vmstat_shepherd in a kernel
> thread and waking up as per defined timeout and then check need_update
> for each CPU and call smp_call_function_single to refresh the timer
> rather than building a mask and then calling sm_call_function_many to
> reduce paralel contention on the shared counters.

Thats ok.
