Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbaAFI7Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 03:59:16 -0500
Received: from smtprelay0176.hostedemail.com ([216.40.44.176]:45438 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751218AbaAFI7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 03:59:14 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3873:4321:5007:7652:7903:8603:10004:10400:10848:11232:11658:11914:12114:12517:12519:12663:12740:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rul
X-HE-Tag: mask73_6d4e2bcd83f1c
X-Filterd-Recvd-Size: 2173
Message-ID: <1388998750.5808.43.camel@joe-AO722>
Subject: Re: [PATCH 4/11]  use ether_addr_equal_64bits
From: Joe Perches <joe@perches.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        kernel-janitors@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 06 Jan 2014 00:59:10 -0800
In-Reply-To: <alpine.DEB.2.10.1401060947550.2079@hadrien>
References: <1388427307-8691-1-git-send-email-Julia.Lawall@lip6.fr>
	 <1388427307-8691-5-git-send-email-Julia.Lawall@lip6.fr>
	 <1388429761.4410.1.camel@jlt4.sipsolutions.net>
	 <alpine.DEB.2.02.1312302057420.2209@localhost6.localdomain6>
	 <1388438724.4573.2.camel@jlt4.sipsolutions.net>
	 <20131230215701.GA4938@khazad-dum.debian.net>
	 <1388445188.18164.0.camel@jlt4.sipsolutions.net>
	 <1388445422.26796.38.camel@joe-AO722>
	 <alpine.DEB.2.10.1401060947550.2079@hadrien>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-06 at 09:48 +0100, Julia Lawall wrote:
> Is there any way to get sizeof evaluated at build time?

I'm confused a bit by what you want to accomplish.

Except for variable length arrays, isn't sizeof always
evaluated at build time?

6.5.3.4 The sizeof operator
Constraints
[]
2 The sizeof operator yields the size (in bytes) of its operand, which may be an
expression or the parenthesized name of a type. The size is determined from the type of
the operand. The result is an integer. If the type of the operand is a variable length array
type, the operand is evaluated; otherwise, the operand is not evaluated and the result is an
integer constant.


