Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760253AbaCUI5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 04:57:43 -0400
Received: from smtprelay0154.hostedemail.com ([216.40.44.154]:52526 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751488AbaCUI5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 04:57:40 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 40,2.5,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:334:355:368:369:379:541:599:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2691:2828:3138:3139:3140:3141:3142:3353:3865:3867:3868:3870:3871:3872:3873:3874:4321:5007:7652:7688:7903:10011:10400:10848:11232:11658:11914:12296:12517:12519:12663:12740:13069:13311:13357:14096:14097:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:1:0
X-HE-Tag: patch04_25b608d8d2530
X-Filterd-Recvd-Size: 2388
Message-ID: <1395392257.7776.74.camel@joe-AO722>
Subject: Re: checkpatch on Kconfig files
From: Joe Perches <joe@perches.com>
To: Jean Delvare <jdelvare@suse.de>, Andi Kleen <andi@firstfloor.org>
Cc: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>
Date: Fri, 21 Mar 2014 01:57:37 -0700
In-Reply-To: <20140321094239.18aebf02@endymion.delvare>
References: <20140321094239.18aebf02@endymion.delvare>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(adding Andi Kleen)

On Fri, 2014-03-21 at 09:42 +0100, Jean Delvare wrote:
> Hi Andy, hi Joe,
> 
> When running checkpatch on a patch which tweaks many Kconfig entries, I
> got the following output:
> 
> WARNING: please write a paragraph that describes the config symbol fully
> #74: FILE: drivers/hid/Kconfig:142:
>  config HID_BELKIN
> 
> WARNING: please write a paragraph that describes the config symbol fully
> #82: FILE: drivers/hid/Kconfig:149:
>  config HID_CHERRY
> 
> WARNING: please write a paragraph that describes the config symbol fully
> #135: FILE: drivers/hid/Kconfig:415:
>  config HID_MICROSOFT
> 
> total: 0 errors, 3 warnings, 88 lines checked
> 
> I am not adding these entries, just tweaking the dependencies. Thus I
> don't think it makes sense to print these warnings, they aren't
> relevant to the changes I am making. There comment in checkpatch says:
> 
> # check for Kconfig help text having a real description
> # Only applies when adding the entry originally, after that we do not have
> # sufficient context to determine whether it is indeed long enough.
> 
> So I suspect these warnings aren't supposed to be displayed. I recall
> hitting this many times in the past, in fact I think this is the most
> frequent and oldest false positive I get from checkpatch. So I would
> appreciate if this could be fixed, either by really limiting the
> warning to Kconfig entries being added (if you can) or by dropping the
> check altogether (if you can't.)

I believe that was Andi Kleen's pet peeve,
so I'll punt it back to him.


