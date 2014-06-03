Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393AbaFCTDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 15:03:17 -0400
Received: from smtprelay0177.hostedemail.com ([216.40.44.177]:40532 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751489AbaFCTDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 15:03:16 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2892:2895:3138:3139:3140:3141:3142:3352:3622:386
X-HE-Tag: card20_1b8e6ace4cb2d
X-Filterd-Recvd-Size: 2185
Message-ID: <1401822187.18833.24.camel@joe-AO725>
Subject: Re: [PATCH v2 RFC 1/3] MAINTAINERS: Add "R:" designated-reviewers
 tag
From: Joe Perches <joe@perches.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, sbw@mit.edu
Date: Tue, 03 Jun 2014 12:03:07 -0700
In-Reply-To: <1401809736-12023-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1401809736-12023-1-git-send-email-paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-03 at 08:35 -0700, Paul E. McKenney wrote:
> Paul Walmsley also noted the need for patch
> submitters to know who the key reviewers are and suggested adding an
> "R:" tag to the MAINTAINERS file to record this information on a
> per-subsystem basis.
[]
> diff --git a/MAINTAINERS b/MAINTAINERS
[]
> @@ -70,6 +70,8 @@ Descriptions of section entries:
>  
>  	P: Person (obsolete)
>  	M: Mail patches to: FullName <address@domain>
> +	R: Designated reviewer, who should be CCed on patches,
> +	   format: FullName <address@domain>
>  	L: Mailing list that is relevant to this area
>  	W: Web-page with status/info
>  	Q: Patchwork web based patch tracking system site

Perhaps the M: and R: roles should be more fully
described here.

The R: entry description doesn't need commas.

Maybe something like:
	M: Maintainer (to:) FullName <address@domain>
	R: Reviewer   (cc:) FullName <address@domain>

You might as well send the get_maintainer update with this
series too.


