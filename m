Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751257AbaJOTNb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 15:13:31 -0400
Received: from mail.kernel.org ([198.145.19.201]:60568 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbaJOTNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 15:13:30 -0400
Date: Wed, 15 Oct 2014 16:13:26 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: kan.liang@intel.com, linux-kernel@vger.kernel.org, ak@linux.intel.com
Subject: Re: [PATCH V8 0/4] perf tools: pmu event new style format fix
Message-ID: <20141015191326.GO3198@kernel.org>
References: <1412694532-23391-1-git-send-email-kan.liang@intel.com>
 <20141015150054.GA20818@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141015150054.GA20818@krava.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Oct 15, 2014 at 05:00:54PM +0200, Jiri Olsa escreveu:
> On Tue, Oct 07, 2014 at 11:08:48AM -0400, kan.liang@intel.com wrote:
> > From: Kan Liang <kan.liang@intel.com>
> > 
> > There are two types of pmu event stytle formats, "pmu_event_name"
> > or "cpu/pmu_event_name/". However, there is a bug on supporting these
> > two formats, especially when they mixed with other perf events.
> > The patch set intends to fix this issue.
> > 
> > The patch set has been tested by perf automated test "./perf test parse -v"
> > on haswell, ivybridge and Romley platform.
> > The patch set also has been tested on haswell by the following script.
> > (Note: please make sure that your test system support TSX and
> > L1-dcache-loads events. Otherwise, you may want to change the events
> > to other pmu events.)
> 
> Acked-by: Jiri Olsa <jolsa@kernel.org>

Thanks, applied the series.

- Arnaldo
