Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240Ab3HVAnX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 20:43:23 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:1061 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752678Ab3HVAnW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 20:43:22 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
From: "Sherman Yin" <syin@broadcom.com>
To: "Linus Walleij" <linus.walleij@linaro.org>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "matt.porter@linaro.org" <matt.porter@linaro.org>,
        "Christian Daudt" <csd@broadcom.com>,
        "Markus Mayer" <mmayer@broadcom.com>,
        "James Hogan" <james.hogan@imgtec.com>
Subject: RE: [PATCH] pinctrl: Pass all configs to driver on
 pin_config_set()
Thread-Topic: [PATCH] pinctrl: Pass all configs to driver on
 pin_config_set()
Thread-Index: AQHOmgj9JDWSFPXUuUqlaxMrv7HnmJmguMIA//+yQ0A=
Date: Thu, 22 Aug 2013 00:43:10 +0000
Message-ID: <051069C10411E24D9749790C498526FA1BDD9D27@SJEXCHMB12.corp.ad.broadcom.com>
References: <1376606573-15093-1-git-send-email-syin@broadcom.com>
 <CACRpkdaUacAbLd+i4Y=DXv=aSaUwBSz6-icPV9SVjxZkUjheww@mail.gmail.com>
In-Reply-To: <CACRpkdaUacAbLd+i4Y=DXv=aSaUwBSz6-icPV9SVjxZkUjheww@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.16.203.100]
MIME-Version: 1.0
X-WSS-ID: 7E0B83B72L876757561-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

>Right now this does not apply to my "devel" branch, so I'd like you
>to rebase on that right now. (This is what will go into v3.12).
>
>This is also late in the development cycle so I believe this is going to
>be v3.13 material unless there are more release candidates.
>
>You can also hold on until after the v3.12 merge window and then
>rebase it and we'll merge it as a first patch in the v3.13 development
>cycle.
>
>What do you say?

You mean the "devel" branch in this tree, right?  Please let me know 
if you're talking about another tree/branch.

git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git

I cherry-picked my commit on top of devel, and there was just a simple
conflict in pinctrl-sunxi.c.  It's easy enough to fix, so I'll send out v2 
that's based on "devel" instead of rc6 anyway.  I can just do another
rebase after v3.12 merge window if needed. 

Thanks!
Sherman




