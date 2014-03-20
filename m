Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922AbaCTLZT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 07:25:19 -0400
Received: from smtprelay0049.hostedemail.com ([216.40.44.49]:58878 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753317AbaCTLZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 07:25:17 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1561:1593:1594:1711:1714:1730:1747:1777:1792:1963:2393:2559:2562:2828:2892:3138:3139:3140:3141:3142:3622:3865:3867:3871:4321:5007:6119:7514:7652:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: river51_6801e3a58745f
X-Filterd-Recvd-Size: 1342
Message-ID: <1395314713.7776.17.camel@joe-AO722>
Subject: Re: [PATCH 1/5] mtd: st_spi_fsm: Remove useless consts from
 function arguments
From: Joe Perches <joe@perches.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        computersforpeace@gmail.com, kernel@stlinux.com,
        linux-mtd@lists.infradead.org, dwmw2@infradead.org, angus.clark@st.com
Date: Thu, 20 Mar 2014 04:25:13 -0700
In-Reply-To: <1395313907-25318-2-git-send-email-lee.jones@linaro.org>
References: <1395313907-25318-1-git-send-email-lee.jones@linaro.org>
	 <1395313907-25318-2-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-20 at 11:11 +0000, Lee Jones wrote:
> Reported-by: Brian Norris <computersforpeace@gmail.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Why are these useless?

Even if the object code produced is the same,
these serve as information to the human reader
about how the arguments are used.


