Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759460AbbA0Smw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 13:42:52 -0500
Received: from smtprelay0084.hostedemail.com ([216.40.44.84]:55333 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754290AbbA0Smt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 13:42:49 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1042:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:2892:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4389:5007:6261:7875:10004:10400:10848:10967:11232:11473:11658:11914:12517:12519:12663:12740:13069:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: copy34_185ae5ded3062
X-Filterd-Recvd-Size: 2409
Date: Tue, 27 Jan 2015 13:42:46 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Borislav Petkov <bp@alien8.de>, Richard Weinberger <richard@nod.at>,
        linux-mmc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH] mmc: print message if a card supports secure erase/trim
Message-ID: <20150127134246.297aae46@gandalf.local.home>
In-Reply-To: <54C7DA10.3040209@ahsoftware.de>
References: <1422359304-30321-1-git-send-email-holler@ahsoftware.de>
	<CAFLxGvyuE8odPdNSD1PTccyBXFm=JO=ooikUOJfz41aFpsUAJg@mail.gmail.com>
	<54C77E69.7050600@ahsoftware.de>
	<20150127120855.GA9254@pd.tnic>
	<54C7816A.8050800@ahsoftware.de>
	<54C78524.3070901@nod.at>
	<54C7881F.6020501@ahsoftware.de>
	<20150127142120.GA3351@pd.tnic>
	<54C7C2EC.7010605@ahsoftware.de>
	<20150127172415.GC25043@home.goodmis.org>
	<54C7CD1C.1060601@ahsoftware.de>
	<20150127124817.608db508@gandalf.local.home>
	<54C7D549.3070705@ahsoftware.de>
	<20150127132148.365ef397@gandalf.local.home>
	<54C7DA10.3040209@ahsoftware.de>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2015 19:33:52 +0100
Alexander Holler <holler@ahsoftware.de> wrote:

> Am 27.01.2015 um 19:21 schrieb Steven Rostedt:
> 
> > You want to add a way to tell a property of a device. That is *exactly*
> > what sysfs was made for. Not dmesg.
> 
> Err, dmesg existed long before sysfs.

Yep, and dmesg shows you what is happening in the kernel. sysfs shows
you the state and properties of the kernel (or devices). That's what it
was created for, because dmesg wasn't the place to put it.

> 
> Anyway, it's ok. You're all right and I should request project 
> sponsoring for offering a simple piece of (imho) interesting information.

I'm sure if it's interesting enough, someone will eventually add it.

Hey, if you end up doing it, it could help with your resume.

> 
> Happy frameworking and sorry for disturbing.

No problem. Enjoy,

-- Steve
