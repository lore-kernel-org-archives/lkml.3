Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933296AbaJVMUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 08:20:23 -0400
Received: from smtprelay0253.hostedemail.com ([216.40.44.253]:44667 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932865AbaJVMUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 08:20:21 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3872:3873:4321:5007:6119:6261:10004:10400:10848:11232:11658:11914:12043:12438:12517:12519:12555:12663:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: party28_3d14a612ad917
X-Filterd-Recvd-Size: 1504
Message-ID: <1413980418.18654.8.camel@perches.com>
Subject: Re: regression: checkpatch.pl fails when called via symlink
From: Joe Perches <joe@perches.com>
To: Jani Nikula <jani.nikula@intel.com>
Cc: Andy Whitcroft <apw@canonical.com>, Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 22 Oct 2014 05:20:18 -0700
In-Reply-To: <874muwv0ym.fsf@intel.com>
References: <874muwv0ym.fsf@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-22 at 13:43 +0300, Jani Nikula wrote:
> Since commit 66b47b4a9dad00e45c049d79966de9a3a1f4d337
> Author: Kees Cook <keescook@chromium.org>
> Date:   Mon Oct 13 15:51:57 2014 -0700
> 
>     checkpatch: look for common misspellings
> 
> checkpatch.pl dies with
> 
> checkpatch.pl: Can't open /path/to/spelling.txt for reading: No such file or directory
> 
> if it's called through a symlink in /path/to/checkpatch.pl pointing at
> the actual script.
> 
> Please fail graciously, and just ignore spelling if you can't find
> spelling.txt. Or better yet, follow the links if you can.

I agree it should fail better, but I'm also curious.
Why you want to use a symlink?


