Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbaILEpR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 00:45:17 -0400
Received: from smtprelay0093.hostedemail.com ([216.40.44.93]:37059 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750863AbaILEpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 00:45:15 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3622:3865:3866:3867:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:7652:8985:9025:10004:10400:10848:11232:11658:11854:11914:12043:12517:12519:12740:13069:13071:13161:13229:13311:13357:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: dolls56_1070245648710
X-Filterd-Recvd-Size: 1764
Message-ID: <1410497111.9942.26.camel@joe-AO725>
Subject: Re: [PATCH v2] checkpatch: look for common misspellings
From: Joe Perches <joe@perches.com>
To: Masanari Iida <standby24x7@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Whitcroft <apw@canonical.com>,
        linux-doc <linux-doc@vger.kernel.org>
Date: Thu, 11 Sep 2014 21:45:11 -0700
In-Reply-To: <CALLJCT1_pB8pEHCCEnNzfQrRR16dGD3rdfjAt40sHXzTBbdEXQ@mail.gmail.com>
References: <20140908181524.GA11839@www.outflux.net>
	 <20140910155219.3d21aef2df8b1754a736cc1a@linux-foundation.org>
	 <CAMuHMdUvBdEKCYezARJ8PvuQPQbi+Wq-fwO+Z2cxYXOtVzp5GQ@mail.gmail.com>
	 <1410444957.9942.3.camel@joe-AO725>
	 <CALLJCT1_pB8pEHCCEnNzfQrRR16dGD3rdfjAt40sHXzTBbdEXQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-12 at 13:09 +0900, Masanari Iida wrote:
> Test with "reseting" case,  codespell found 21, grep found 26.

Hello Masanari.

How did codespell find any uses of reseting?
What version of codespell are you using?
(I tested with 1.7)

Looking at the git tree for codespell,
https://github.com/lucasdemarchi/codespell.git
the dictionary there doesn't have reseting.

If I add reseting->resetting to the dictionary,
then codespell finds the same 31 uses that
git grep -i does.


