Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856Ab3JIW6E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 18:58:04 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:4949 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755682Ab3JIW6B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 18:58:01 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
From: "Sherman Yin" <syin@broadcom.com>
To: "Linus Walleij" <linus.walleij@linaro.org>
cc: "Rob Herring" <rob.herring@calxeda.com>, "Pawel Moll" <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "Rob Landley" <rob@landley.net>, "Christian Daudt" <bcm@fixthebug.org>,
        "Russell King" <linux@arm.linux.org.uk>,
        "Grant Likely" <grant.likely@linaro.org>,
        "Matt Porter" <matt.porter@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 1/4] pinctrl: Add void * to pinctrl_pin_desc
Thread-Topic: [PATCH 1/4] pinctrl: Add void * to pinctrl_pin_desc
Thread-Index: AQHOwJjv/0q2+wwWM0+ko0Aw5Ba9t5nsjr+AgAB1lfA=
Date: Wed, 9 Oct 2013 22:57:51 +0000
Message-ID: <051069C10411E24D9749790C498526FA1BE01EFC@SJEXCHMB12.corp.ad.broadcom.com>
References: <1380846199-12829-1-git-send-email-syin@broadcom.com>
 <1380846199-12829-2-git-send-email-syin@broadcom.com>
 <CACRpkdaMODd9=fZPC+-FMJ1tWw95DBGjsu4DEzKqrNhGpYSARA@mail.gmail.com>
In-Reply-To: <CACRpkdaMODd9=fZPC+-FMJ1tWw95DBGjsu4DEzKqrNhGpYSARA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.16.203.100]
MIME-Version: 1.0
X-WSS-ID: 7E4B00E54FK113182-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> ---
>> Change-Id: I78b2c44b93d88b04897fd0af80ffce213e338d6b
>
>Why are you giving me this funky Gerrit stuff along with the patch?
>It's not like I have any use for it, and anything below the three
>dashes will be deleted when applying.
>
>The patch is OK but won't be applied until some driver is
>using it (i.e. this BRCM one...)

Sorry, I didn't remove it since it's after the 3 dashes and will be 
discarded anyway.  Will remove Change-Id: from future patches.

Regards,
Sherman

