Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420AbaFBSok (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 14:44:40 -0400
Received: from smtprelay0168.hostedemail.com ([216.40.44.168]:33208 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752135AbaFBSoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 14:44:39 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3865:3866:3867:38
X-HE-Tag: toy59_61e8330869955
X-Filterd-Recvd-Size: 1765
Message-ID: <1401734669.7323.20.camel@joe-AO725>
Subject: Re: [PATCH RFC 1/2] MAINTAINERS: Add "R:" designated-reviewers tag
From: Joe Perches <joe@perches.com>
To: paulmck@linux.vnet.ibm.com
Cc: josh@joshtriplett.org, linux-kernel@vger.kernel.org, mingo@kernel.org,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Date: Mon, 02 Jun 2014 11:44:29 -0700
In-Reply-To: <20140602181658.GX22231@linux.vnet.ibm.com>
References: <1401728420-3572-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1401729778.5770.20.camel@joe-AO725> <20140602174837.GA13257@cloud>
	 <1401731968.7323.4.camel@joe-AO725>
	 <20140602181658.GX22231@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-02 at 11:16 -0700, Paul E. McKenney wrote:
> But there have been people who have found serious issues in RCU patches
> who I would not trust as full maintainers.  The ability to find defects
> is valuable in and of itself, and should be recognized as such, even
> when not accompanied by the rest of the maintainership package.

Maybe, but odd-lot reviewers are most likely going to find
these same defects regardless of any "R" designation in
MAINTAINERS.


