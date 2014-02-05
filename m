Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbaBENyV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 08:54:21 -0500
Received: from 6.mo3.mail-out.ovh.net ([188.165.43.173]:49753 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751835AbaBENyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 08:54:16 -0500
Message-ID: <52F24255.9030603@overkiz.com>
Date: Wed, 05 Feb 2014 14:53:25 +0100
From: Boris BREZILLON <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>
CC: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, dev@linux-sunxi.org,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Huang Shijie <b32955@freescale.com>
Subject: Re: [RFC PATCH 1/9] mtd: nand: retrieve ECC requirements from Hynix
 READ ID byte 4
References: <1389190924-26226-1-git-send-email-b.brezillon@overkiz.com> <1389190924-26226-2-git-send-email-b.brezillon@overkiz.com> <20140123014906.GY8919@ld-irv-0074>
In-Reply-To: <20140123014906.GY8919@ld-irv-0074>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 4782541329942673631
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrjedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.501258/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrjedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Brian,

On 23/01/2014 02:49, Brian Norris wrote:
> + Huang
>
> Hi Boris,
>
> On Wed, Jan 08, 2014 at 03:21:56PM +0100, Boris BREZILLON wrote:
>> The Hynix nand flashes store their ECC requirements in byte 4 of its id
>> (returned on READ ID command).
>>
>> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> I haven't verified yet (perhaps Huang can confirm?), but this may be
> similar to a patch Huang submitted recently. In his case, we found that
> this table is actually quite unreliable and is likely hard to maintain.

Indeed (as stated in this thread 
http://comments.gmane.org/gmane.linux.drivers.mtd/50252).
I'll remove this patch from the next version of this series and make use 
of the
nand-ecc-strength /nand-ecc-size DT properties instead.

Thanks.

Best Regards,

Boris
>
> Why do you need this ECC information, for my reference?
>
> Brian

