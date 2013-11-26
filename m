Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476Ab3KZR3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 12:29:13 -0500
Received: from smtprelay0102.hostedemail.com ([216.40.44.102]:34973 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932317Ab3KZR3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 12:29:11 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1515:1516:1518:1534:1537:1559:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3870:3876:4321:5007:7652:7901:10004:10400:10848:11232:11658:11914:12043:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: goat20_89de8fdbdd553
X-Filterd-Recvd-Size: 1340
Message-ID: <1385486940.20100.60.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: add DT compatible string documentation check
From: Joe Perches <joe@perches.com>
To: Rob Herring <robherring2@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>,
        Andy Whitcroft <apw@canonical.com>
Date: Tue, 26 Nov 2013 09:29:00 -0800
In-Reply-To: <CAL_JsqKgUQZT4g3fgPe-h8G-zWb1gnfxgT20BDrL+zS5u4URzg@mail.gmail.com>
References: <1385481675-26675-1-git-send-email-robherring2@gmail.com>
	 <1385484225.20100.58.camel@joe-AO722>
	 <CAL_JsqKgUQZT4g3fgPe-h8G-zWb1gnfxgT20BDrL+zS5u4URzg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-26 at 11:11 -0600, Rob Herring wrote:
> I think we don't really want '+' (or '_') in compatible strings.

What about lines like:
arch/powerpc/boot/dts/kmeter1.dts:  compatible = "ucc_geth";


