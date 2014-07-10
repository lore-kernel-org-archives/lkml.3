Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbaGJKBu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 06:01:50 -0400
Received: from smtprelay0233.hostedemail.com ([216.40.44.233]:39601 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751942AbaGJKBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 06:01:48 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:960:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1566:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3867:3870:3871:3872:3874:432
X-HE-Tag: fog85_497b0bd797f5c
X-Filterd-Recvd-Size: 1761
Message-ID: <1404986503.8839.24.camel@joe-AO725>
Subject: Re: [PATCH v1 1/5] seq_file: provide an analogue of print_hex_dump()
From: Joe Perches <joe@perches.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Marek Vasut <marex@denx.de>, Tadeusz Struk <tadeusz.struk@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Helge Deller <deller@gmx.de>,
        Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>, linux390@de.ibm.com,
        Alexander Viro <viro@zeniv.linux.org.uk>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, linux-media@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 10 Jul 2014 03:01:43 -0700
In-Reply-To: <1404985839.5102.97.camel@smile.fi.intel.com>
References: <1404919470-26668-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <201407092239.30561.marex@denx.de> <1404940868.932.168.camel@joe-AO725>
	 <201407100958.02218.marex@denx.de>
	 <1404985839.5102.97.camel@smile.fi.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-10 at 12:50 +0300, Andy Shevchenko wrote:
> I have considered to modify hex_dump_to_buffer() to return how many
> bytes it actually proceed to the buffer. In that case we can directly
> print to m->buf like other seq_<foo> calls do.
> 
> But I still have doubts about it. Any opinion?

Simpler is better.


