Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab3HZCrK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 22:47:10 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:2177 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755195Ab3HZCrI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 22:47:08 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
From: "Sherman Yin" <syin@broadcom.com>
To: "Linus Walleij" <linus.walleij@linaro.org>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "Matt Porter" <matt.porter@linaro.org>,
        "Stephen Warren (swarren@wwwdotorg.org)" <swarren@wwwdotorg.org>
Subject: RE: [PATCH v2] pinctrl: Pass all configs to driver on
 pin_config_set()
Thread-Topic: [PATCH v2] pinctrl: Pass all configs to driver on
 pin_config_set()
Thread-Index: AQHOntXJmgdj0T+r5kuSCtgUWAQalJmjh/cAgANGgmA=
Date: Mon, 26 Aug 2013 02:46:56 +0000
Message-ID: <051069C10411E24D9749790C498526FA1BDDCD3B@SJEXCHMB12.corp.ad.broadcom.com>
References: <1376606573-15093-1-git-send-email-syin@broadcom.com>
 <1377134300-25480-1-git-send-email-syin@broadcom.com>
 <CACRpkdZeET601+jOsjQxu-VAhi1owgtMX60Fij=uU489eGVFXg@mail.gmail.com>
In-Reply-To: <CACRpkdZeET601+jOsjQxu-VAhi1owgtMX60Fij=uU489eGVFXg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.16.203.100]
MIME-Version: 1.0
X-WSS-ID: 7E041F310UO442618-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

>Didn't you get review from Stephen Warren?

Yes, just wasn't sure when those tags should be added.  They have been 
added to v3 now.

>Please try to put all the maintainers for the above files on the To: line
>so they get a chance to review/ack the patch.

Ok.  I've added the emails from get_maintainer.pl for each of the files.
v3 has been rebased today and I also applied the API changes to 
pinctrl-palmas.c

Regards,
Sherman

