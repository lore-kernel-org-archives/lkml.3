Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721Ab3JKF3H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 01:29:07 -0400
Received: from smtprelay0149.hostedemail.com ([216.40.44.149]:33111 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753452Ab3JKF3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 01:29:05 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1567:1593:1594:1711:1714:1730:1747:1777:1792:2194:2199:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3622:3865:3867:3868:3870:3871:3872:3874:4321:4470:5007:6119:7652:7903:8792:9108:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:no
X-HE-Tag: crush14_31e7d8fafe638
X-Filterd-Recvd-Size: 1444
Message-ID: <1381469341.14017.39.camel@joe-AO722>
Subject: Re: [PATCH v3a] vsprintf: Check real user/group id for %pK
From: Joe Perches <joe@perches.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: George Spelvin <linux@horizon.com>, ebiederm@xmission.com,
        akpm@linux-foundation.org, dan.j.rosenberg@gmail.com,
        eldad@fogrefinery.com, jgunthorpe@obsidianresearch.com,
        jkosina@suse.cz, keescook@chromium.org,
        kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk
Date: Thu, 10 Oct 2013 22:29:01 -0700
In-Reply-To: <52578A4D.2000300@gmail.com>
References: <20131011044232.11545.qmail@science.horizon.com>
	 <52578A4D.2000300@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-11 at 16:19 +1100, Ryan Mallon wrote:
> Yeah, that is probably the best solution. I'll try to put together a
> patch series doing this. It will obviously be more involved though, so I
> think it is still worth merging the original patch in the interm.

I just submitted a patch neatening and shrinking
the original code without the cred changes.

Maybe build on that?

