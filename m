Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbaJ2CwO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 22:52:14 -0400
Received: from cnbjrel01.sonyericsson.com ([219.141.167.165]:2453 "EHLO
	cnbjrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755057AbaJ2CwN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 22:52:13 -0400
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Will Deacon'" <will.deacon@arm.com>
CC: "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'akinobu.mita@gmail.com'" <akinobu.mita@gmail.com>
Date: Wed, 29 Oct 2014 10:52:08 +0800
Subject: RE: [RFC V3] arm/arm64:add CONFIG_HAVE_ARCH_BITREVERSE to support
 rbit instruction
Thread-Topic: [RFC V3] arm/arm64:add CONFIG_HAVE_ARCH_BITREVERSE to support
 rbit instruction
Thread-Index: Ac/yt3RrdcC2TGvVRDGxkId1vLsT0gAa8Naw
Message-ID: <35FD53F367049845BC99AC72306C23D103E010D1825D@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D103E010D18254@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18257@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18259@CNBJMBX05.corpusers.net>
 <20141027104848.GD8768@arm.com>
 <35FD53F367049845BC99AC72306C23D103E010D1825A@CNBJMBX05.corpusers.net>
 <20141028135944.GC29706@arm.com>
In-Reply-To: <20141028135944.GC29706@arm.com>
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

> From: Will Deacon [mailto:will.deacon@arm.com]
> Yup, sorry, I didn't realise this patch covered both architectures. It
> would probably be a good idea to split it into 3 parts: a core part, then
> the two architectural bits.
> 
> Will

Ok ,
I will split the patch into three parts,
And send again .

Thanks
