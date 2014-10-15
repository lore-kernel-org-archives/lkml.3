Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572AbaJOPBD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 11:01:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41685 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbaJOPBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 11:01:01 -0400
Date: Wed, 15 Oct 2014 17:00:54 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: kan.liang@intel.com
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com, acme@kernel.org
Subject: Re: [PATCH V8 0/4] perf tools: pmu event new style format fix
Message-ID: <20141015150054.GA20818@krava.redhat.com>
References: <1412694532-23391-1-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412694532-23391-1-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 11:08:48AM -0400, kan.liang@intel.com wrote:
> From: Kan Liang <kan.liang@intel.com>
> 
> There are two types of pmu event stytle formats, "pmu_event_name"
> or "cpu/pmu_event_name/". However, there is a bug on supporting these
> two formats, especially when they mixed with other perf events.
> The patch set intends to fix this issue.
> 
> The patch set has been tested by perf automated test "./perf test parse -v"
> on haswell, ivybridge and Romley platform.
> The patch set also has been tested on haswell by the following script.
> (Note: please make sure that your test system support TSX and
> L1-dcache-loads events. Otherwise, you may want to change the events
> to other pmu events.)

Acked-by: Jiri Olsa <jolsa@kernel.org>

thanks,
jirka
