Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590AbaIDVQM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 17:16:12 -0400
Received: from smtprelay0174.hostedemail.com ([216.40.44.174]:46567 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754041AbaIDVQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 17:16:11 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2687:2828:2915:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:5007:7652:7875:7903:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13141:13230:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: fold69_35cfc85f1b953
X-Filterd-Recvd-Size: 1672
Message-ID: <1409865368.2770.20.camel@joe-AO725>
Subject: Re: [PATCH v4] checkpatch: allow optional shorter config
 descriptions
From: Joe Perches <joe@perches.com>
To: Vadim Bendebury <vbendeb@chromium.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Andy Whitcroft <apw@canonical.com>
Date: Thu, 04 Sep 2014 14:16:08 -0700
In-Reply-To: <1409865234-19708-1-git-send-email-vbendeb@chromium.org>
References: <1409761945-545-1-git-send-email-vbendeb@chromium.org>
	 <1409865234-19708-1-git-send-email-vbendeb@chromium.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-09-04 at 14:13 -0700, Vadim Bendebury wrote:
> This script is used by many other projects, and in some of them the
> requirement of at least 4 line long description for all Kconfig items
> is excessive. This patch adds a command line option to control the
> required minimum length.
> 
> Tested running this script over a patch including a two line config
> description. The script generated a warning when invoked as is, and
> did not generate it when invoked with --min-conf-desc-length=2.
> 
> Signed-off-by: Vadim Bendebury <vbendeb@chromium.org>
> ---
> 
> Changes in v4:
>   - added the missing trailing semicolon. Re-tested to verify that it
>     still works as expected.

Acked-by: Joe Perches <joe@perches.com>

