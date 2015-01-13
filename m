Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbbAMM14 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 07:27:56 -0500
Received: from smtprelay0016.hostedemail.com ([216.40.44.16]:45154 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751749AbbAMM1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 07:27:54 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1538:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2895:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3874:5007:6261:6742:7875:7903:10004:10400:10450:10455:10848:10967:11232:11658:11914:12517:12519:12663:12740:13069:13255:13311:13357:19904:19999:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: wish63_a699e82c9a35
X-Filterd-Recvd-Size: 2218
Date: Tue, 13 Jan 2015 07:27:50 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Daniel Drake <drake@endlessm.com>,
        Dmitry Pervushin <dpervushin@gmail.com>,
        Tim Sander <tim@krieglstein.org>, Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH 3.19-rc2 v13 4/5] ARM: Add support for on-demand
 backtrace of other CPUs
Message-ID: <20150113072750.432e792e@gandalf.local.home>
In-Reply-To: <54B4F52D.8010403@linaro.org>
References: <1415968543-29469-1-git-send-email-daniel.thompson@linaro.org>
	<1420469699-25350-1-git-send-email-daniel.thompson@linaro.org>
	<1420469699-25350-5-git-send-email-daniel.thompson@linaro.org>
	<20150105101925.64e8ecec@gandalf.local.home>
	<20150109164801.GW12302@n2100.arm.linux.org.uk>
	<20150111183700.55ea2434@gandalf.local.home>
	<54B4F52D.8010403@linaro.org>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2015 10:36:29 +0000
Daniel Thompson <daniel.thompson@linaro.org> wrote:

> > We could change that hard coded 4096 to PAGE_SIZE, for those archs with
> > bigger pages.
> 
> I've just updated the patchset with a couple of patches to common up the
> printk code between arm and x86.
> 
> Just for the record I haven't changed the hard coded 4096 as part of
> this. I'd be quite happy to but I didn't want to introduce any "secret"
> changes to the code whilst the patch header claims I am just copying stuff.

Adding a separate patch would be fine by me.

-- Steve
