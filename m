Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115AbaIWTE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 15:04:29 -0400
Received: from smtprelay0139.hostedemail.com ([216.40.44.139]:59022 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753337AbaIWTE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 15:04:28 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3167:3352:3622:3865:3866:3867:3870:3871:3872:4321:5007:7652:7808:7904:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bean87_99676d46812a
X-Filterd-Recvd-Size: 2059
Message-ID: <1411499064.29268.6.camel@joe-AO725>
Subject: Re: [PATCH 0/7] Silence even more W=2 warnings
From: Joe Perches <joe@perches.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "Rustad, Mark D" <mark.d.rustad@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "sparse@chrisli.org" <sparse@chrisli.org>,
        "linux-sparse@vger.kernel.org" <linux-sparse@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 23 Sep 2014 12:04:24 -0700
In-Reply-To: <20140923184456.GA16467@pd.tnic>
References: <20140922184049.GB4709@pd.tnic>
	 <3199350A-89CE-4BE7-8FE4-CA8CE4F87622@intel.com>
	 <20140922192152.GD4709@pd.tnic>
	 <1411415057.2513.8.camel@jtkirshe-mobl.jf.intel.com>
	 <20140922195737.GE4709@pd.tnic>
	 <1411416573.2513.19.camel@jtkirshe-mobl.jf.intel.com>
	 <20140922203336.GF4709@pd.tnic>
	 <A05C31E6-7AD2-482A-B590-A5ED57D028B3@intel.com>
	 <20140923082209.GB22072@pd.tnic>
	 <029E2CFB-C001-4E16-B1F7-A3FB193E3138@intel.com>
	 <20140923184456.GA16467@pd.tnic>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-23 at 20:44 +0200, Borislav Petkov wrote:
> On Tue, Sep 23, 2014 at 05:24:22PM +0000, Rustad, Mark D wrote:
> > Perhaps checkpatch would be a better gatekeeper for new code. OTOH,
> > some of those nested externs have already been eliminated, so at
> > least for now the warning is serving a purpose since it is scrubbing
> > existing code.
> 
> Yep, eliminating would be optimal. If it is in checkpatch, it is much
> easier to manage.

checkpatch is simply a regex tester, so it's only appropriate
if the false-positive false-negative rate is acceptable.

Coccinelle may be better at whatever test is being considered.


