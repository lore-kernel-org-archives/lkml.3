Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246AbbA0Ome (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 09:42:34 -0500
Received: from smtprelay0046.hostedemail.com ([216.40.44.46]:57724 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753728AbbA0Omc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 09:42:32 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1537:1561:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:3138:3139:3140:3141:3142:3622:3865:3867:3871:3874:5007:6119:6120:6261:7875:10004:10400:10848:10967:11232:11658:11914:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: show38_6d2265ce0d11d
X-Filterd-Recvd-Size: 1544
Date: Tue, 27 Jan 2015 09:42:28 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Dominik Vogt <vogt@linux.vnet.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Masami Hiramatsu <maasami.hiramatsu.pt@hitachi.com>,
        Vojtech Pavlik <vojtech@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>,
        Andreas Krebbel <krebbel@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC 2/3] ftrace: introduce nohotpatch function attribute
Message-ID: <20150127094228.50e642fc@gandalf.local.home>
In-Reply-To: <20150127061941.GA4591@linux.vnet.ibm.com>
References: <1422276894-31302-1-git-send-email-heiko.carstens@de.ibm.com>
	<1422276894-31302-3-git-send-email-heiko.carstens@de.ibm.com>
	<20150126093701.699763dc@gandalf.local.home>
	<20150127061941.GA4591@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2015 07:19:42 +0100
Dominik Vogt <vogt@linux.vnet.ibm.com> wrote:
 
> While the kernel may use only profiling or hotpatch at the same
> time, Gcc is able to generate both for the same function.

Understood, but would that be useful for the kernel?

-- Steve

