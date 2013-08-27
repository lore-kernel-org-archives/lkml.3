Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab3H0Qjj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 12:39:39 -0400
Received: from 8.mo1.mail-out.ovh.net ([178.33.110.239]:56759 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753273Ab3H0Qji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 12:39:38 -0400
X-Greylist: delayed 12011 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Aug 2013 12:39:37 EDT
Message-ID: <521CD61C.8010103@overkiz.com>
Date: Tue, 27 Aug 2013 18:38:52 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: nicolas.ferre@atmel.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org, ian.campbell@citrix.com,
        linux@arm.linux.org.uk, f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: Re: [PATCH 0/2] net/cadence/macb: add support for dt phy definition
References: <1377186980-21902-1-git-send-email-b.brezillon@overkiz.com> <20130826.160450.2176892065062148718.davem@davemloft.net> <521C586A.7080604@overkiz.com> <20130827.122056.419758783951274884.davem@davemloft.net>
In-Reply-To: <20130827.122056.419758783951274884.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 15428487900348512293
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrheeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrheeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/08/2013 18:20, David Miller wrote:
> From: boris brezillon <b.brezillon@overkiz.com>
> Date: Tue, 27 Aug 2013 09:42:34 +0200
>
>> Could you apply, the 3rd version of this series instead ?
> There can never be an "instead" or reverting patches I've said I've
> applied already.
>
> If you want changes, you have to submit follow-on fixes.

Hello David,

I sent the incremental patches based on your net-next branch:
https://lkml.org/lkml/2013/8/27/257
https://lkml.org/lkml/2013/8/27/259

Thanks.

Best Regards,

Boris
