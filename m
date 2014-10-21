Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbaJUI2c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 04:28:32 -0400
Received: from smtprelay0229.hostedemail.com ([216.40.44.229]:39416 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751120AbaJUI23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:28:29 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2895:2911:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3873:4184:4250:4321:4425:5007:6119:6261:7903:10004:10394:10400:10848:11232:11658:11914:12043:12517:12519:12555:12740:13069:13071:13311:13357:14096:14097:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: song68_fb518c727d59
X-Filterd-Recvd-Size: 1741
Message-ID: <1413880105.12828.3.camel@perches.com>
Subject: Re: checkpatch false positive
From: Joe Perches <joe@perches.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 21 Oct 2014 01:28:25 -0700
In-Reply-To: <54461602.4000705@redhat.com>
References: <54461602.4000705@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-21 at 10:14 +0200, Hans de Goede wrote:
> Hi,
> 
> Checkpatch gives the following warning:
> 
> WARNING: added, moved or deleted file(s), does MAINTAINERS need updating?
> #31:
> new file mode 100644
> 
> total: 0 errors, 1 warnings, 352 lines checked
> 
> 0001-input-Add-new-sun4i-lradc-keys-driver.patch has style problems, please review.
> 
> If any of these errors are false positives, please report
> them to the maintainer, see CHECKPATCH in MAINTAINERS.
> 
> On a patch of mine, even though it updates MAINTAINERS properly, it would
> be nice if checkpatch would check for a hunk updating MAINTAINERS, and then
> would not issue this warning (note my perl-foo is way too weak to fix this
> myself).
> 
> I've attached the patch triggering the warning.

Hi Hans.

It's not really fixable.  Of course you are welcome to
try though.

Many patches are discrete and the entire series isn't
visible to a single MAINTAINERS update scan by checkpatch.


