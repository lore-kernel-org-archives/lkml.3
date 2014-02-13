Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516AbaBMGLp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 01:11:45 -0500
Received: from 1.mo2.mail-out.ovh.net ([46.105.63.121]:47975 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750892AbaBMGLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 01:11:43 -0500
MIME-Version: 1.0
In-Reply-To: <20140212210446.GF11498@piout.net>
References: <1392199607-27452-1-git-send-email-jjhiblot@traphandler.com>
	<1392199607-27452-4-git-send-email-jjhiblot@traphandler.com>
	<20140212210446.GF11498@piout.net>
Date: Thu, 13 Feb 2014 07:11:38 +0100
Message-ID: <CACh+v5O0fJAvT0Ze9RkcVgLQ22Lod+m1ACj0K=GLLA=9r5tVvg@mail.gmail.com>
Subject: Re: [PATCH v4 3/8] at91: dt: Add at91sam9261 dt SoC support
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        boris brezillon <b.brezillon@overkiz.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
X-Ovh-Tracer-Id: 7066992240636352536
X-Ovh-Remote: 209.85.160.49 (mail-pb0-f49.google.com)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrjedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrkeejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-02-12 22:04 GMT+01:00 Alexandre Belloni
<alexandre.belloni@free-electrons.com>:
> Sorry, one more comment on that patch:
>
> On 12/02/2014 at 11:06:42 +0100, Jean-Jacques Hiblot wrote :
>> +                     pinctrl@fffff400 {
>> +                             #address-cells = <1>;
>> +                             #size-cells = <1>;
>> +                             compatible = "atmel,at91rm9200-pinctrl", "simple-bus";
>> +                             ranges = <0xfffff400 0xfffff400 0xa00>;
>> +
> I believe you got the range wrong, shouldn't it be:
>                                 ranges = <0xfffff400 0xfffff400 0x600>;
>
Yes you're right.
Thanks for the review
>
> --
> Alexandre Belloni, Free Electrons
> Embedded Linux, Kernel and Android engineering
> http://free-electrons.com
