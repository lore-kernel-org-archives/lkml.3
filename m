Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875AbaGIVVT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 17:21:19 -0400
Received: from smtprelay0049.hostedemail.com ([216.40.44.49]:33394 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755141AbaGIVVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 17:21:17 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:960:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2198:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3865:3866:3867:3868:387
X-HE-Tag: tub22_7e9deed0a4513
X-Filterd-Recvd-Size: 1889
Message-ID: <1404940868.932.168.camel@joe-AO725>
Subject: Re: [PATCH v1 1/5] seq_file: provide an analogue of print_hex_dump()
From: Joe Perches <joe@perches.com>
To: Marek Vasut <marex@denx.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Tadeusz Struk <tadeusz.struk@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Helge Deller <deller@gmx.de>,
        Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>, linux390@de.ibm.com,
        Alexander Viro <viro@zeniv.linux.org.uk>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, linux-media@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 09 Jul 2014 14:21:08 -0700
In-Reply-To: <201407092239.30561.marex@denx.de>
References: <1404919470-26668-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1404919470-26668-2-git-send-email-andriy.shevchenko@linux.intel.com>
	 <201407092239.30561.marex@denx.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-09 at 22:39 +0200, Marek Vasut wrote:
> The above function looks like almost verbatim copy of print_hex_dump(). The only 
> difference I can spot is that it's calling seq_printf() instead of printk(). Can 
> you not instead generalize print_hex_dump() and based on it's invocation, make 
> it call either seq_printf() or printk() ?

How do you propose doing that given any seq_<foo> call
requires a struct seq_file * and print_hex_dump needs
a KERN_<LEVEL>.

Is there an actual value to it?



