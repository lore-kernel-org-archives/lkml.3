Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100AbaIBJMj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 05:12:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbaIBJMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 05:12:38 -0400
Date: Tue, 2 Sep 2014 11:12:24 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: kan.liang@intel.com
Cc: acme@kernel.org, linux-kernel@vger.kernel.org, ak@linux.intel.com
Subject: Re: [PATCH v3 2/3] perf tools: parse the pmu event prefix and surfix
Message-ID: <20140902091224.GB8044@krava.redhat.com>
References: <1409588987-11998-1-git-send-email-kan.liang@intel.com>
 <1409588987-11998-2-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409588987-11998-2-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 12:29:46PM -0400, kan.liang@intel.com wrote:
> From: Kan Liang <kan.liang@intel.com>
> 
> There are two types of event formats for PMU events. E.g. el-abort OR
> cpu/el-abort/. However, the lexer mistakenly recognizes the simple style
> format as two events.
> 
> The parse_events_pmu_check function uses bsearch to search the name in
> known pmu event list. It can tell the lexer that the name is a PE_NAME
> or a PMU event name prefix or a PMU event name suffix. All these
> information will be used for accurately parsing kernel PMU events.
> 
> The pmu events list will be read from sysfs at runtime.

this one does not apply to latest acme's perf/core

could you please rebase your patchset to:
  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf/core

thanks,
jirka
