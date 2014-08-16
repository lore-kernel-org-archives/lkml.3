Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824AbaHPUN0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 16:13:26 -0400
Received: from smtprelay0221.hostedemail.com ([216.40.44.221]:53590 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751782AbaHPUNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 16:13:24 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:960:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2692:2828:3138:3139:3140:3141:3142:3351:3622:3865:3866:3867:3868:3871:3872:3874:4250:4321:5007:7652:10004:10400:10848:11026:11232:11658:11914:12517:12519:12740:13069:13161:13229:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: hat00_61f878b1942
X-Filterd-Recvd-Size: 1428
Message-ID: <1408220001.2683.103.camel@joe-AO725>
Subject: Re: [PATCH] staging: android: binder.c: rename binder_user_error()
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tair Rzayev <tair.rzayev@gmail.com>, arve@android.com,
        linux-kernel@vger.kernel.org
Date: Sat, 16 Aug 2014 13:13:21 -0700
In-Reply-To: <20140815064532.GA20920@kroah.com>
References: <53E7CB3D.3030403@gmail.com> <20140815064532.GA20920@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-08-15 at 14:45 +0800, Greg KH wrote:
> On Sun, Aug 10, 2014 at 10:42:53PM +0300, Tair Rzayev wrote:
> > Rename binder_user_error() to shorter but no less readable binder_usr_err()
> > which fixes 34 "line over 80 characters" checkpatch warnings
> 
> Those are false-positives due to the fact that we should not wrap
> strings and checkpatch doesn't understand this custom macro.
> 
> So don't worry about it, the code is fine as-is.

Using <foo>_err instead of <foo>_error means that
checkpatch can successfully ignore long lines of
the format portion of this macro.


