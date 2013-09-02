Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037Ab3IBCmt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 22:42:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:20607 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754889Ab3IBCmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 22:42:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1003,1367996400"; 
   d="scan'208";a="396869046"
Date: Sun, 1 Sep 2013 19:42:47 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCHv2 00/25] perf tool: Add support for multiple data file
 storage
Message-ID: <20130902024247.GI16724@tassilo.jf.intel.com>
References: <1378031796-17892-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378031796-17892-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 01, 2013 at 12:36:11PM +0200, Jiri Olsa wrote:
> hi,
> sending the support for multiple file storage. Initial
> RFC is here:
> http://marc.info/?l=linux-kernel&m=137408381902423&w=2

Just a general comment. If you repost please always keep the overview
description/motivation in 0/0.

-Andi

