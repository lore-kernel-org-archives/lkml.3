Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbaCRJif (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 05:38:35 -0400
Received: from ni.piap.pl ([195.187.100.4]:41103 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbaCRJie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 05:38:34 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Anton Vorontsov <anton@enomsg.org>, Yinghai Lu <yinghai@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, arm@kernel.org
References: <m3eh2nqz7n.fsf@t19.piap.pl> <m3r46io1nd.fsf@t19.piap.pl>
	<m3eh2inxef.fsf@t19.piap.pl> <201403171537.19546.arnd@arndb.de>
Date: Tue, 18 Mar 2014 10:36:43 +0100
In-Reply-To: <201403171537.19546.arnd@arndb.de> (Arnd Bergmann's message of
	"Mon, 17 Mar 2014 15:37:19 +0100")
MIME-Version: 1.0
Message-ID: <m3a9cnkfv8.fsf@t19.piap.pl>
Content-Type: text/plain
Subject: Re: [PATCH v2] CNS3xxx: Fix PCIe early iotable_init().
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE,
	 bases: 20140318 #7538934, check: 20140318 clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> Applied to next/fixes-non-critical.
>
> Since the problem is not new and you didn't mark the patch as 'stable',
> this seems to be the right place. Let us know if you need backports
> to stable kernels, also fo the other patch.

Sure, BTW there is also that problem with PCI bridge configuration or
something (maybe on certain boards only) which I can't fix at the
moment, but will do eventually. So absolutely no rush with this/these
patch(es) alone. I just want to make CNS3xxx some valid platform (the
same with IXP4xx and I also have some i.MX6 stuff) but it has to wait
for now.

Thanks,
-- 
Krzysztof Halasa

Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
