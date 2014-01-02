Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750899AbaABBiH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 20:38:07 -0500
Received: from smtprelay0007.hostedemail.com ([216.40.44.7]:49043 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750704AbaABBiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 20:38:06 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:960:968:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1536:1560:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3866:3868:5007:7652:10004:10400:10848:11658:11914:12517:12519:12533:12679:13069:13138:13231:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: dad86_63546a8a4b418
X-Filterd-Recvd-Size: 1360
Message-ID: <1388626680.2259.58.camel@joe-AO722>
Subject: Re: [PATCH] lib/vsprintf: add %pT[C012] format specifier
From: Joe Perches <joe@perches.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: akpm@linux-foundation.org, geert@linux-m68k.org, jkosina@suse.cz,
        viro@zeniv.linux.org.uk, davem@davemloft.net, keescook@chromium.org,
        linux-kernel@vger.kernel.org
Date: Wed, 01 Jan 2014 17:38:00 -0800
In-Reply-To: <201401011902.JEF43770.FSOVFFOHOtQLJM@I-love.SAKURA.ne.jp>
References: <1388422545.26796.36.camel@joe-AO722>
	 <201312311553.IGG09071.HLJtFVSQFFOOOM@I-love.SAKURA.ne.jp>
	 <1388507067.2259.24.camel@joe-AO722>
	 <201401011434.GAF34360.FFQOVtFOHJSMLO@I-love.SAKURA.ne.jp>
	 <1388555362.2259.38.camel@joe-AO722>
	 <201401011902.JEF43770.FSOVFFOHOtQLJM@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

btw: Those -6.6 field width uses really are just for debugging
and I think should be removed.  I didn't notice any other uses of
field widths and current-><value>.  Are there any?

