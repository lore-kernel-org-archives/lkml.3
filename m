Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbaBLMgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 07:36:17 -0500
Received: from 1.mo2.mail-out.ovh.net ([46.105.63.121]:32845 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751199AbaBLMgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 07:36:16 -0500
MIME-Version: 1.0
In-Reply-To: <20140212133449.5c42216d@skate>
References: <1392199607-27452-1-git-send-email-jjhiblot@traphandler.com>
	<52FB5795.9020708@free-electrons.com>
	<20140212133449.5c42216d@skate>
Date: Wed, 12 Feb 2014 13:36:08 +0100
Message-ID: <CACh+v5Nv7u4WSXttvsnMPxwNwN6R4ZDRABOXr9XXBjy6mSDi5w@mail.gmail.com>
Subject: Re: [PATCH v4 0/8] Device Tree support for the at91sam9261ek
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        boris brezillon <b.brezillon@overkiz.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
X-Ovh-Tracer-Id: 7716355012036286488
X-Ovh-Remote: 209.85.220.45 (mail-pa0-f45.google.com)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrjedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrkeehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,


2014-02-12 13:34 GMT+01:00 Thomas Petazzoni
<thomas.petazzoni@free-electrons.com>:
> Dear Gregory CLEMENT,
>
> On Wed, 12 Feb 2014 12:14:29 +0100, Gregory CLEMENT wrote:
>
>> For dm9000 the issue is (again) related to an ordering problem:
>> the Ethernet need an interrupt provided by the gpio driver. Unfortunately,
>> the gpio driver initialization is called after the dm900 driver
>> initialization.
>
> And -EPROBE_DEFER doesn't solve this problem?
not really the problem happens before the driver is actually probed
when the ressource for the platform driver are filled
>
> Thomas
> --
> Thomas Petazzoni, CTO, Free Electrons
> Embedded Linux, Kernel and Android engineering
> http://free-electrons.com
