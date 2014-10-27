Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399AbaJ0HNz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 03:13:55 -0400
Received: from cnbjrel01.sonyericsson.com ([219.141.167.165]:10942 "EHLO
	cnbjrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751752AbaJ0HNy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 03:13:54 -0400
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Joe Perches'" <joe@perches.com>
CC: "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'Will Deacon'" <Will.Deacon@arm.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'akinobu.mita@gmail.com'" <akinobu.mita@gmail.com>
Date: Mon, 27 Oct 2014 15:13:50 +0800
Subject: RE: [RFC V2] arm/arm64:add CONFIG_HAVE_ARCH_BITREVERSE to support
 rbit instruction
Thread-Topic: [RFC V2] arm/arm64:add CONFIG_HAVE_ARCH_BITREVERSE to support
 rbit instruction
Thread-Index: Ac/xsbWsvpUYtHz/QbmB40QKeJ42aAAA7E+A
Message-ID: <35FD53F367049845BC99AC72306C23D103E010D18258@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D103E010D18254@CNBJMBX05.corpusers.net>
	 <35FD53F367049845BC99AC72306C23D103E010D18257@CNBJMBX05.corpusers.net>
 <1414392371.8884.2.camel@perches.com>
In-Reply-To: <1414392371.8884.2.camel@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> 
> If this is done, the direct uses of byte_rev_table in
> drivers/net/wireless/ath/carl9170/phy.c and sound/usb/6fire/firmware.c
> should be converted too?
> 

I think use bitrev8()  is safer than to use byte_rev_table[]  directly.

