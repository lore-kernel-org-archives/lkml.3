Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbaGGI1e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 04:27:34 -0400
Received: from mx0.aculab.com ([213.249.233.131]:33040 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752089AbaGGI1c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 04:27:32 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Joe Perches'" <joe@perches.com>,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] vsprintf: Remove SPECIAL from pointer types
Thread-Topic: [PATCH] vsprintf: Remove SPECIAL from pointer types
Thread-Index: AQHPmJHlxHkyHWSKhk2L64hzwr0mDJuUR2BQ
Date: Mon, 7 Jul 2014 08:26:06 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1726D4E1@AcuExch.aculab.com>
References: <alpine.LFD.2.11.1406290246120.15455@eddie.linux-mips.org>
	 <20140702.182807.1245632778216212860.davem@davemloft.net>
	 <alpine.LFD.2.11.1407030244230.15455@eddie.linux-mips.org>
	 <alpine.LFD.2.11.1407030331550.15455@eddie.linux-mips.org>
	 <1404356734.14741.18.camel@joe-AO725>
	 <alpine.LFD.2.11.1407030423300.15455@eddie.linux-mips.org>
	 <1404364565.14741.26.camel@joe-AO725>
	 <alpine.LFD.2.11.1407030637030.15455@eddie.linux-mips.org>
	 <1404368746.14741.36.camel@joe-AO725>
	 <alpine.LFD.2.11.1407051529040.15455@eddie.linux-mips.org>
	 <1404576420.6384.41.camel@joe-AO725>
	 <alpine.LFD.2.11.1407051833400.15455@eddie.linux-mips.org>
	 <1404583739.6384.51.camel@joe-AO725>
	 <alpine.LFD.2.11.1407051917480.15455@eddie.linux-mips.org>
	 <1404585099.6384.53.camel@joe-AO725>
	 <alpine.LFD.2.11.1407052103130.15455@eddie.linux-mips.org>
 <1404593114.6384.72.camel@joe-AO725>
In-Reply-To: <1404593114.6384.72.camel@joe-AO725>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches
> Because gcc issues a complaint about any pointer format with %#p,
> remove the use of SPECIAL to prefix 0x to various pointer types.
> 
> There are no uses in the kernel tree of %#p.

I know you guys don't really care about them, but there might
be uses in out of tree drivers.

With the change what is output for %#p ?

I know I've used %#p in some code (possibly userspace) that need
to run under multiple OS because 0x%p generates 0x0x on one of the OS.
(We might have removed them because of the gcc warning though.)

	David



