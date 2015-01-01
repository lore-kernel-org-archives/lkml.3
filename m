Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751180AbbAAFkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 00:40:19 -0500
Received: from smtprelay0123.hostedemail.com ([216.40.44.123]:33927 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750713AbbAAFkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 00:40:17 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::,RULES_HIT:41:355:379:541:599:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3872:3873:4321:5007:6261:7903:10004:10400:10848:11026:11232:11658:11914:12517:12519:12740:13069:13161:13229:13311:13357:21080:21088,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: feast38_7687a66ce7618
X-Filterd-Recvd-Size: 1782
Message-ID: <1420090813.6066.9.camel@perches.com>
Subject: Re: [PATCH v3 2/4] staging: rtl8192u: fix whitespace
From: Joe Perches <joe@perches.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>, gregkh@linuxfoundation.org,
        anarey@gmail.com, mcgrof@do-not-panic.com, tapaswenipathak@gmail.com,
        rmfrfs@gmail.com, yejiayily@gmail.com, gdonald@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Wed, 31 Dec 2014 21:40:13 -0800
In-Reply-To: <20150101044756.GA3645@sudip-PC>
References: <1420060243-10685-2-git-send-email-lstoakes@gmail.com>
	 <1420061623-11136-1-git-send-email-lstoakes@gmail.com>
	 <20150101044756.GA3645@sudip-PC>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2015-01-01 at 10:17 +0530, Sudip Mukherjee wrote:
> On Wed, Dec 31, 2014 at 09:33:43PM +0000, Lorenzo Stoakes wrote:
> > This patch fixes warnings/errors raised by checkpatch.pl relating to whitespace
> > in r8192U_dm.c and additionally it removes inconsistent whitespace
> > throughout.
> > 
> > Additionally some 0x00... padding has been added for alignment to the
> > edca_setting_* variables.
> 
> i may be wrong, but looks like you are doing many different things in the patch, not just whitespace errors.
> marked a few, please see inline - 

Don't get carried away with patch type separation
and please remember to trim your replies to just
the areas you comment on.


