Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab3AOTul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 14:50:41 -0500
Received: from xes-mad.com ([216.165.139.218]:51727 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755137Ab3AOTuj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 14:50:39 -0500
X-Greylist: delayed 2589 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jan 2013 14:50:39 EST
Date: Tue, 15 Jan 2013 13:07:28 -0600 (CST)
From: Aaron Sierra <asierra@xes-inc.com>
To: =?iso-8859-1?Q?Ag=F3cs_P=E1l?= <agocs.pal.86@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] linux-3.7.2 lpc_ich.c: fix gpio base and control offsets
Message-ID: <c655ed07-4535-4613-a990-a93c1218e5a9@zimbra>
In-Reply-To: <20130114184250.5182708e@palee-debian>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Originating-IP: [10.52.0.65]
X-Mailer: Zimbra 7.1.3_GA_3346 (ZimbraWebClient - GC20 (Linux)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In ICH5 and before the GPIOBASE and GPIOCTRL are 0x58 and 0x5C. This
> patch updates lpc_ich.c that supports ICH5 and before GPIO. This
> patch
> fix the "I/O space for GPIO uninitialized" message.
> Reference: 252516-001, 252517-028: 82801EB (ICH5), 82801ER (ICH5R)
> documents from developer.intel.com.
> 
> Signed-off-by: Agócs Pál <agocs.pal.86@gmail.com>
> 

Agócs,
Thanks for finding and correcting this issue. I had trouble applying
your patch because it seems to have not come through as purely plain
text. I manually integrated your changes into my tree and made a few
additional changes that simplify some of the other driver code. I
will CC you shortly with this version.

-Aaron
