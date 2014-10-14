Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190AbaJNNCx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 09:02:53 -0400
Received: from mga14.intel.com ([192.55.52.115]:36501 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755229AbaJNNCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 09:02:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="399999148"
Message-ID: <1413291739.7906.88.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 3/4] UBI: Fastmap: Care about the protection queue
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: Richard Weinberger <richard@nod.at>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Tue, 14 Oct 2014 16:02:19 +0300
In-Reply-To: <543D1545.8090209@codeaurora.org>
References: <1412029248-22454-1-git-send-email-richard@nod.at>
	 <1412029248-22454-4-git-send-email-richard@nod.at>
	 <1412346676.3795.62.camel@sauron.fi.intel.com> <542EF3BF.1070401@nod.at>
	 <1413206263.7906.18.camel@sauron.fi.intel.com> <543BE21F.5020504@nod.at>
	 <1413213803.7906.45.camel@sauron.fi.intel.com> <543C3E60.4080507@nod.at>
	 <1413282203.7906.72.camel@sauron.fi.intel.com>
	 <543D1545.8090209@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-14 at 15:21 +0300, Tanya Brokhman wrote:
> Hi Artem/Richard
> 
> I think your discussion here stopped being relevant to this specific 
> patch but went on to the fastmap feature design in general :)
> This patch fixes a real bug in the current implementation of the 
> feature. What you're discussing requires a re-writing and re-design of 
> the feature. Perhaps this one can be merged and will be "fixed" later on 
> when you agree on how you would like FM to access WL data structures in 
> general?

First of all, "re-writing and re-design of the feature" is an
overstatement. So far this is on the "cleaning things up" side of the
spectrum, closer to the "re-factoring" area.

WRT "merge the fix now and improve later" - this is a good argument for
an "inside a company" discussion, where the primary TTM is the driving
factor.

For the community TTM is a good thing, but quality comes first.

Now, if this was about a regression, one could apply time pressure on
the maintainer. But we are talking about a problem which was there from
day 0.

It is completely normal for the maintainer to push back various
hot-fixes for the problem and request some reasonable re-factoring
first. This is what I do. This is very very usual thing in the Linux
community.

So far I did not ask anything huge and unreasonable, I think. Just
cleaner inter-subsystem APIs, less of the "fastmap uses the other
subsystems' internals" kind of things.

--
Artem.

