Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570AbaLaVUN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 16:20:13 -0500
Received: from smtprelay0245.hostedemail.com ([216.40.44.245]:51420 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751080AbaLaVUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 16:20:11 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:968:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3872:3874:4321:5007:6261:7903:10004:10400:10848:11026:11232:11473:11658:11914:12043:12517:12519:12555:12740:13069:13311:13357:21080:21088,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: jar06_75b59e926fc18
X-Filterd-Recvd-Size: 1991
Message-ID: <1420060806.6066.1.camel@perches.com>
Subject: Re: [PATCH v2 2/4] staging: rtl8192u: fix whitespace
From: Joe Perches <joe@perches.com>
To: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: gregkh@linuxfoundation.org, anarey@gmail.com, mcgrof@do-not-panic.com,
        tapaswenipathak@gmail.com, rmfrfs@gmail.com, yejiayily@gmail.com,
        gdonald@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Wed, 31 Dec 2014 13:20:06 -0800
In-Reply-To: <1420060243-10685-2-git-send-email-lstoakes@gmail.com>
References: <1420060243-10685-1-git-send-email-lstoakes@gmail.com>
	 <1420060243-10685-2-git-send-email-lstoakes@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-31 at 21:10 +0000, Lorenzo Stoakes wrote:
> This patch fixes warnings/errors raised by checkpatch.pl relating to whitespace
> in r8192U_dm.c and additionally it removes inconsistent whitespace throughout.
[]
> diff --git a/drivers/staging/rtl8192u/r8192U_dm.c b/drivers/staging/rtl8192u/r8192U_dm.c
[]
> +static u32 edca_setting_DL[HT_IOT_PEER_MAX] = {
> +	0x5e4322, 0x5e4322, 0x5e4322, 0x604322, 0xa44f, 0x5ea44f
> +};
> +static u32 edca_setting_UL[HT_IOT_PEER_MAX] = {
> +		0x5e4322, 0xa44f, 0x5e4322, 0x604322, 0x5ea44f, 0x5ea44f
> +};

It'd be nicer to use the same form and indentation
for both entries.

Probably be nicer to use:

static u32 edca_setting_DL[HT_IOT_PEER_MAX] = {
	0x5e4322, 0x5e4322, 0x5e4322, 0x604322, 0x00a44f, 0x5ea44f
};
static u32 edca_setting_UL[HT_IOT_PEER_MAX] = {
	0x5e4322, 0x00a44f, 0x5e4322, 0x604322, 0x5ea44f, 0x5ea44f
};

so that the entries align too.

Would it be better to use const?


