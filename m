Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbaIZClC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 22:41:02 -0400
Received: from cnbjrel01.sonyericsson.com ([219.141.167.165]:11450 "EHLO
	cnbjrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752386AbaIZClA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 22:41:00 -0400
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Catalin Marinas'" <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Will Deacon <Will.Deacon@arm.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'linux-arm-msm@vger.kernel.org'" <linux-arm-msm@vger.kernel.org>,
        =?iso-8859-1?Q?=27Uwe_Kleine-K=F6nig=27?= 
	<u.kleine-koenig@pengutronix.de>,
        DL-WW-ContributionOfficers-Linux 
	<DL-WW-ContributionOfficers-Linux@sonymobile.com>
Date: Fri, 26 Sep 2014 10:40:54 +0800
Subject: RE: [PATCH resend] arm:extend the reserved memory for initrd to be
 page aligned
Thread-Topic: [PATCH resend] arm:extend the reserved memory for initrd to be
 page aligned
Thread-Index: Ac/Y15GJS/OdjTIxTdagaUoaJnJjvQAWwnEA
Message-ID: <35FD53F367049845BC99AC72306C23D103D6DB49163B@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D103D6DB49161F@CNBJMBX05.corpusers.net>
 <20140919095959.GA2295@e104818-lin.cambridge.arm.com>
 <20140925143142.GF5182@n2100.arm.linux.org.uk>
 <20140925154403.GL10390@e104818-lin.cambridge.arm.com>
In-Reply-To: <20140925154403.GL10390@e104818-lin.cambridge.arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> They were so close ;)
> 
> I can see three patches but none of them exactly right:
> 
> 8157/1 - wrong diff format
> 8159/1 - correct format, does not have my ack (you can take this one if
> 	 you want)
> 8162/1 - got my ack this time but with the wrong diff format again
> 
> Maybe a pull request is a better idea.
> 
I am really confused, 
I read this web:
http://www.arm.linux.org.uk/developer/patches/info.php
it said use diff -urN to generate patch like this:

diff -Nru linux.orig/lib/string.c linux/lib/string.c

but I see other developers use git format-patch to generate patch and
submit to the patch system.
Git format-patch format can also be accepted by the patch system correctly ?
If yes, I think this web should update,
Use git format-patch to generate patch is more convenient than use diff -urN 

Thanks



