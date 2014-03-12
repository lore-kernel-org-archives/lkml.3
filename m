Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888AbaCLTu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 15:50:57 -0400
Received: from smtprelay0011.hostedemail.com ([216.40.44.11]:60874 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750751AbaCLTu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 15:50:56 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:2896:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3874:4250:4321:5007:6119:7652:7903:10004:10400:10848:11232:11658:11914:12043:12517:12519:12740:13069:13311:13357:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: owl13_7c01ea5d6365e
X-Filterd-Recvd-Size: 1748
Message-ID: <1394653850.3915.26.camel@joe-AO722>
Subject: Re: [PATCH v3] power: add an API to log wakeup reasons
From: Joe Perches <joe@perches.com>
To: Ruchi Kandoi <kandoiruchi@google.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, rjw@rjwysocki.net,
        ghackmann@google.com, john.stultz@linaro.org, toddpoynor@google.com
Date: Wed, 12 Mar 2014 12:50:50 -0700
In-Reply-To: <1394653598-17143-1-git-send-email-kandoiruchi@google.com>
References: <1394653598-17143-1-git-send-email-kandoiruchi@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-12 at 12:46 -0700, Ruchi Kandoi wrote:
> For power management diagnostic purposes, it is often useful to know
> what interrupts are frequently waking the system from low power
> suspend mode, especially on battery-powered consumer electronics
> devices that are expected to spend much of their time in low-power
> suspend while not in active use.  For example, reduced battery life on
> a mobile phone may be caused in part by frequent wakeups by broadcast
> traffic on a busy wireless LAN even while the screen is off and the
> phone not in active use.

trivial note:

> diff --git a/kernel/power/wakeup_reason.c b/kernel/power/wakeup_reason.c
[]
> +#define pr_fmt(fmt) "wakeup_reason:" fmt

It's almost universal in the kernel to have a space after the :
in the prefix

#define pr_fmt(fmt) "wakeup_reason: " fmt


