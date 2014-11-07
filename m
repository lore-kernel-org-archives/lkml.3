Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741AbaKGKLF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 05:11:05 -0500
Received: from smtprelay0061.hostedemail.com ([216.40.44.61]:45145 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751585AbaKGKLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 05:11:02 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:421:541:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3867:3868:3872:3873:3874:4321:5007:6261:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: beast61_886c2a15db31
X-Filterd-Recvd-Size: 1627
Message-ID: <1415355054.23530.8.camel@perches.com>
Subject: Re: [RESEND PATCH 3.18-rc3] kdb: Avoid printing KERN_ levels to
 consoles
From: Joe Perches <joe@perches.com>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Jason Wessel <jason.wessel@windriver.com>, linux-kernel@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Date: Fri, 07 Nov 2014 02:10:54 -0800
In-Reply-To: <545C9791.7050608@linaro.org>
References: <1411555097-16924-1-git-send-email-daniel.thompson@linaro.org>
	 <1415287626-25802-1-git-send-email-daniel.thompson@linaro.org>
	 <1415290399.6634.52.camel@perches.com> <545BAE67.1060602@linaro.org>
	 <1415295835.6634.56.camel@perches.com> <545C9791.7050608@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-07 at 09:57 +0000, Daniel Thompson wrote:

> Does that arguing against Cc:ing stable@ or you think I should just put
> that on anyway and leave it for the stable committee?

It's a regression, I think you should send a fix
for it to stable.  It's up to the stable folks to
figure out if they want to take it.


