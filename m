Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbaFBRXG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 13:23:06 -0400
Received: from smtprelay0088.hostedemail.com ([216.40.44.88]:59491 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750701AbaFBRXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 13:23:04 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2691:2693:2828:2892:3138:3139:3140:3141:3142:3353:362
X-HE-Tag: stage95_71773c7de9747
X-Filterd-Recvd-Size: 2478
Message-ID: <1401729778.5770.20.camel@joe-AO725>
Subject: Re: [PATCH RFC 1/2] MAINTAINERS: Add "R:" designated-reviewers tag
From: Joe Perches <joe@perches.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, sbw@mit.edu
Date: Mon, 02 Jun 2014 10:22:58 -0700
In-Reply-To: <1401728420-3572-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1401728420-3572-1-git-send-email-paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-02 at 10:00 -0700, Paul E. McKenney wrote:
> A ksummit-discuss email thread looked at the difficulty recruiting
> and retaining reviewers.

[]

> Paul Walmsley also noted the need for patch
> submitters to know who the key reviewers are and suggested adding an
> "R:" tag to the MAINTAINERS file to record this information on a
> per-subsystem basis.

I'm not sure of the value of this.

Why not just mark the actual reviewers as maintainers?

The lack of reviewers problem is entirely distinct from
the proposed solution.

I believe active reviewers will generally subscribe to a
subsystem specific mailing list.

Perhaps it'd be better to get a "linux-rcu@vger.kernel.org"
mailing list going.

> diff --git a/MAINTAINERS b/MAINTAINERS
[]
> @@ -73,6 +73,8 @@ Descriptions of section entries:
>  	L: Mailing list that is relevant to this area
>  	W: Web-page with status/info
>  	Q: Patchwork web based patch tracking system site
> +	R: Designated reviewer, who should be CCed on patches,
> +	   format: FullName <address@domain>
>  	T: SCM tree type and location.
>  	   Type is one of: git, hg, quilt, stgit, topgit
>  	S: Status, one of the following:

If this is actually done, I suggest putting this
"R" entry description immediately after the "M" entry.


