Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932961Ab3CYSgv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 14:36:51 -0400
Received: from a192-166.smtp-out.amazonses.com ([199.255.192.166]:6416 "EHLO
	a192-166.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932748Ab3CYSgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 14:36:50 -0400
X-Greylist: delayed 558 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Mar 2013 14:36:50 EDT
Date: Mon, 25 Mar 2013 18:27:30 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <clark@redhat.com>
Subject: Re: [RT LATENCY] 249 microsecond latency caused by slub's
 unfreeze_partials() code.
In-Reply-To: <1364234613.6345.184.camel@gandalf.local.home>
Message-ID: <0000013da2ce20f8-0e3a64ef-67ed-4ab4-9f20-b77980c876c3-000000@email.amazonses.com>
References: <1363906545.6345.81.camel@gandalf.local.home> <0000013d92c37ff3-5fb85400-bec1-4eda-8ba1-332566884c59-000000@email.amazonses.com> <1364010673.6345.156.camel@gandalf.local.home> <0000013da1f93be3-c3d42ae8-ff34-4c63-8094-77a83291ea19-000000@email.amazonses.com>
 <1364227073.6345.182.camel@gandalf.local.home> <1364228039.6345.183.camel@gandalf.local.home> <0000013da2ace21a-9e87fe8a-75c2-4b7c-b5e1-37ad196ce012-000000@email.amazonses.com> <1364234613.6345.184.camel@gandalf.local.home>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.192.166
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Mar 2013, Steven Rostedt wrote:

> If this makes it more deterministic, and lower worse case latencies,
> then it's definitely worth the price.

Yes that would make it more deterministic. Maybe I should add an option
to be able to compile the allocator without cpu partial page support?

