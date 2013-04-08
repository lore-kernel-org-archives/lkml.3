Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762730Ab3DHJLw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:11:52 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55786 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab3DHJLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:11:51 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: "Nori, Sekhar" <nsekhar@ti.com>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "Manjunathappa, Prakash" <prakash.pm@ti.com>,
        "jacmet@sunsite.dk" <jacmet@sunsite.dk>
Subject: RE: [PATCH v3 3/3] ARM: davinci: da850: add EHRPWM & ECAP DT node
Thread-Topic: [PATCH v3 3/3] ARM: davinci: da850: add EHRPWM & ECAP DT node
Thread-Index: AQHOKS19PuoEahWsUk2VKlRRhE1ixJjCSvgAgAnS9HA=
Date: Mon, 8 Apr 2013 09:09:59 +0000
Deferred-Delivery: Mon, 8 Apr 2013 09:09:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3EAA91B6@DBDE01.ent.ti.com>
References: <1364197789-16783-1-git-send-email-avinashphilip@ti.com>
 <1364197789-16783-4-git-send-email-avinashphilip@ti.com>
 <515A97DE.1080403@ti.com>
In-Reply-To: <515A97DE.1080403@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r389BpAb024127

On Tue, Apr 02, 2013 at 14:03:34, Nori, Sekhar wrote:
> On 3/25/2013 1:19 PM, Philip Avinash wrote:
> > Add da850 EHRPWM & ECAP DT node.
> > Also adds OF_DEV_AUXDATA for EHRPWM & ECAP driver to use EHRPWM & ECAP
> > clock.
> 
> This looks fine to me but I will wait for the bindings to get accepted
> before taking this one.

Sekhar,

Binding document got accepted in PWM tree [1].
Can you accept this patch?

1. https://gitorious.org/linux-pwm

Thanks
Avinash

> 
> Thanks,
> Sekhar
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
