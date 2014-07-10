Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbaGJOWk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 10:22:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:37992 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbaGJOWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 10:22:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,638,1400050800"; 
   d="scan'208";a="571157461"
Date: Thu, 10 Jul 2014 07:22:08 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        namhyung@kernel.org, acme@infradead.org
Subject: Re: [PATCH 3/9] perf, tools: Add support for reading JSON event
 files v3
Message-ID: <20140710142208.GC19781@tassilo.jf.intel.com>
References: <1403910964-11017-1-git-send-email-andi@firstfloor.org>
 <1403910964-11017-4-git-send-email-andi@firstfloor.org>
 <20140709221958.GH20938@krava.redhat.com>
 <20140710000554.GP18735@two.firstfloor.org>
 <20140710062508.GA24705@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140710062508.GA24705@krava.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 08:25:08AM +0200, Jiri Olsa wrote:
> On Thu, Jul 10, 2014 at 02:05:54AM +0200, Andi Kleen wrote:
> > On Thu, Jul 10, 2014 at 12:19:58AM +0200, Jiri Olsa wrote:
> > > Im confused, your branch shows v4 in patch Subject,
> > > while this patch has v3... ?
> > 
> > Patchkits and patches both have their own numeric 
> > version spaces.
> 
> yes, but this specific patch has higher (different) version
> in the branch, that patch you sent

Yes the branch contains an unposted version.

Only change was just the manpage changes that were requested
during review.

-Andi
