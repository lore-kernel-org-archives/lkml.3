Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704AbaGIS0c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 14:26:32 -0400
Received: from smtprelay0088.hostedemail.com ([216.40.44.88]:44255 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752746AbaGIS03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 14:26:29 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1560:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3866:3867:4321:5007:7652:10004:10400:10848:11026:11232:11658
X-HE-Tag: spade50_37f3fb890e83b
X-Filterd-Recvd-Size: 1666
Message-ID: <1404930382.932.143.camel@joe-AO725>
Subject: Re: [PATCH v1 4/5] parisc: use seq_hex_dump() to dump buffers
From: Joe Perches <joe@perches.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Helge Deller <deller@gmx.de>,
        Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>, linux390@de.ibm.com,
        Alexander Viro <viro@zeniv.linux.org.uk>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, linux-media@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 09 Jul 2014 11:26:22 -0700
In-Reply-To: <1404919470-26668-5-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1404919470-26668-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1404919470-26668-5-git-send-email-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-09 at 18:24 +0300, Andy Shevchenko wrote:
> Instead of custom approach let's use recently introduced seq_hex_dump() helper.

Doesn't this also change the output from
   1111111122222222333333334444444455555555666666667777777788888888
to
   11111111 22222222 33333333 44444444 55555555 66666666 77777777 88888888


