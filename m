Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042Ab3GWUxE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 16:53:04 -0400
Received: from mx11.netapp.com ([216.240.18.76]:39672 "EHLO mx11.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757933Ab3GWUxC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 16:53:02 -0400
X-IronPort-AV: E=Sophos;i="4.89,730,1367996400"; 
   d="scan'208";a="35935249"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Henrik Rydberg <rydberg@euromail.se>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andre Heider <a.heider@gmail.com>
Subject: Re: Linux 3.11-rc2
Thread-Topic: Linux 3.11-rc2
Thread-Index: AQHOh0Blpp07UcC9oUem7v4bwneG7Zlx67KAgAEg6oCAAApigIAAGjqAgAACwQA=
Date: Tue, 23 Jul 2013 20:52:38 +0000
Message-ID: <1374612758.12943.4.camel@leira.trondhjem.org>
References: <CA+55aFy330bSRjK5HT1n0wXioPykL3RquHXyBPjm5GpTz_Y=DQ@mail.gmail.com>
	 <20130723010437.GA570@polaris.bitmath.org>
	 <1374542261.7972.66.camel@leira.trondhjem.org>
	 <1374604305.12943.3.camel@leira.trondhjem.org>
	 <20130723190855.GA509@polaris.bitmath.org>
	 <CA+55aFwpwJ3MgVtbNZQXjCV+06xq1xk=XO1OYwoscvO3SQth3A@mail.gmail.com>
In-Reply-To: <CA+55aFwpwJ3MgVtbNZQXjCV+06xq1xk=XO1OYwoscvO3SQth3A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.106.53.51]
Content-Type: text/plain; charset="utf-8"
Content-ID: <8A34197DBFBBB241BDB9A04E36AE7834@hq.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6NKr8Tq022095

On Tue, 2013-07-23 at 13:42 -0700, Linus Torvalds wrote:
> On Tue, Jul 23, 2013 at 12:08 PM,  <rydberg@euromail.se> wrote:
> > Hi Trond,
> >
> >> OK. With Andre's help, I think we've root caused the problem. Can you
> >> please confirm that the attached patch also solves the issue for you?
> >
> > Seems to work fine,
> >
> >    Reported-and-tested-by: Henrik Rydberg <rydberg@euromail.se>
> 
> Trond, do you have anything else pending and are planning a git pull,
> or should I just take this patch directly?

Nothing else queued for now, so if you could take it directly, then that
would save the trouble of setting up an extra pull.

Thanks!
-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
