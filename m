Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab3FGPgJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 11:36:09 -0400
Received: from mo1.mail-out.ovh.net ([178.32.228.1]:58966 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584Ab3FGPgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 11:36:08 -0400
X-Greylist: delayed 340 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Jun 2013 11:36:08 EDT
Message-ID: <51B1FDE1.8090109@overkiz.com>
Date: Fri, 07 Jun 2013 17:36:01 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: Re: [RFC PATCH 02/50] ARM: at91: add PMC main clock
References: <1370615115-16979-1-git-send-email-b.brezillon@overkiz.com> <1370615115-16979-3-git-send-email-b.brezillon@overkiz.com> <20130607173014.7186ddc0@skate>
In-Reply-To: <20130607173014.7186ddc0@skate>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 18262377964928596074
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrgedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrgedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2013 17:30, Thomas Petazzoni wrote:
> Dear Boris BREZILLON,
>
> On Fri,  7 Jun 2013 16:24:10 +0200, Boris BREZILLON wrote:
>
>> + * This mainram is free software; you can redistribute it and/or modify
> Looks like you did some funky 'sed' over your source files. In every
> clk driver, instead of "program" you have "<name of clock>ram" :-)
Oups.

I based all my implementations on programmable clocks and replaced every 
instance
of the "prog" pattern by the clock name.
That's why "program" is replaced by "<name of clock>ram".

I'll fix it.

Thanks
>
> Thomas

