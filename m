Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502AbbAINbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 08:31:18 -0500
Received: from smtprelay0170.hostedemail.com ([216.40.44.170]:34486 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757192AbbAINbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 08:31:17 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:599:960:967:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3351:3622:3865:3867:3871:3872:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:5007:6261:8985:9025:10004:10394:10400:10848:11232:11658:11854:11914:12043:12296:12517:12519:12555:12679:12740:13069:13095:13161:13163:13229:13311:13357:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sand14_28184b0d8b217
X-Filterd-Recvd-Size: 1460
Message-ID: <1420810273.32628.2.camel@perches.com>
Subject: Re: checkpatch wrong error message
From: Joe Perches <joe@perches.com>
To: Daniel Baluta <daniel.baluta@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 09 Jan 2015 05:31:13 -0800
In-Reply-To: <CAEnQRZDKhgSV=+P_M9aJP-+8DftxVmjgHgAR7OAxFUku6RHsHw@mail.gmail.com>
References: <CAEnQRZDKhgSV=+P_M9aJP-+8DftxVmjgHgAR7OAxFUku6RHsHw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2015-01-09 at 13:57 +0200, Daniel Baluta wrote:
> Hi Joe,
> 
> Running ./scripts/checkpatch on the attached [1] patch i get the
> following error:
> 
> ERROR: Please use 12 or more chars for the git commit ID like: 'commit
> 01234567890ab ("commit description")'
> #6:
> After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is

checkpatch uses the same message for multiple forms.

There were some patches around to make this clearer.
https://lkml.org/lkml/2014/10/20/630

Your commit message does not have quotes around the text.

It should be:

After commit <2b49ccbdd54 ("PM: Kconfig: Set ...")


