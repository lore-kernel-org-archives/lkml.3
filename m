Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464AbaCTMN4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 08:13:56 -0400
Received: from smtprelay0204.hostedemail.com ([216.40.44.204]:49491 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750916AbaCTMNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 08:13:55 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3866:3867:3870:3871:3872:3874:4321:5007:7652:7903:9389:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: blade42_5c162dc464827
X-Filterd-Recvd-Size: 1661
Message-ID: <1395317630.7776.29.camel@joe-AO722>
Subject: Re: [PATCH 1/5] mtd: st_spi_fsm: Remove useless consts from
 function arguments
From: Joe Perches <joe@perches.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Brian Norris <computersforpeace@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, linux-mtd@lists.infradead.org, dwmw2@infradead.org,
        angus.clark@st.com
Date: Thu, 20 Mar 2014 05:13:50 -0700
In-Reply-To: <20140320120307.GA9240@lee--X1>
References: <1395313907-25318-1-git-send-email-lee.jones@linaro.org>
	 <1395313907-25318-2-git-send-email-lee.jones@linaro.org>
	 <1395314713.7776.17.camel@joe-AO722> <20140320114123.GE21349@lee--X1>
	 <1395316090.7776.24.camel@joe-AO722>
	 <20140320115412.GU31517@norris-Latitude-E6410>
	 <20140320120307.GA9240@lee--X1>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-20 at 12:03 +0000, Lee Jones wrote:
> > Good catch. That wasn't my intention.
> > > Why?
> An oversight.

That's still not an explanation.

Why, unless cast away by the code itself, is
const removal a good thing?

It does serve as an indication to a reader what
the code does with the argument.

About the only reason I can think of arguing in
favor of removal is inconsistent application of
const within the module.


