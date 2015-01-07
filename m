Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031AbbAGCZP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:25:15 -0500
Received: from smtprelay0116.hostedemail.com ([216.40.44.116]:39162 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755034AbbAGCZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:25:12 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1566:1593:1594:1711:1714:1730:1747:1777:1792:2110:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3622:3865:3867:3868:3872:3874:4321:5007:6261:7875:7974:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13149:13230:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: jar17_4a20c652eb607
X-Filterd-Recvd-Size: 1221
Message-ID: <1420597507.28667.2.camel@perches.com>
Subject: Re: [PATCH v3 1/3] pstore: use scnprintf
From: Joe Perches <joe@perches.com>
To: Mark Salyzyn <salyzyn@android.com>
Cc: linux-kernel@vger.kernel.org, Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>, Kees Cook <keescook@chromium.org>,
        Tony Luck <tony.luck@intel.com>
Date: Tue, 06 Jan 2015 18:25:07 -0800
In-Reply-To: <1420571907-13162-1-git-send-email-salyzyn@android.com>
References: <1420571907-13162-1-git-send-email-salyzyn@android.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-06 at 11:18 -0800, Mark Salyzyn wrote:
> No guarantees that the names will not exceed the
> name buffer with future adjustments.

It'd be nice to describe the changes between versions.

Typically, it's done after the --- line separating the
changelog and sign-off and the patch.

cheers, Joe

