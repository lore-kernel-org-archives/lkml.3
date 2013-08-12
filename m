Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab3HLUqn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 16:46:43 -0400
Received: from 4.mo2.mail-out.ovh.net ([87.98.172.75]:52364 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751429Ab3HLUqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 16:46:42 -0400
Message-ID: <520949AE.6080207@overkiz.com>
Date: Mon, 12 Aug 2013 22:46:38 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: balbi@ti.com
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [PATCH] usb: gadget: at91_udc: add usb_clk for transition to
 common clk framework
References: <1375337885-2684-1-git-send-email-b.brezillon@overkiz.com> <5208E881.3030205@atmel.com> <20130812180851.GF27954@radagast>
In-Reply-To: <20130812180851.GF27954@radagast>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 5309462486740007109
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrudejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrudejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Felipe

On 12/08/2013 20:08, Felipe Balbi wrote:
> On Mon, Aug 12, 2013 at 03:52:01PM +0200, Nicolas Ferre wrote:
>> On 01/08/2013 08:18, Boris BREZILLON :
>>> The AT91 PMC (Power Management Controller) provides an USB clock used by
>>> USB Full Speed host (ohci) and USB Full Speed device (udc).
>>> The usb drivers (ohci and udc) must configure this clock to 48Mhz.
>>> This configuration was formely done in mach-at91/clock.c, but this
>>> implementation will be removed when moving to common clk framework.
>>>
>>> This patch adds support for usb clock retrieval and configuration, and is
>>> backward compatible with the current at91 clk implementation (if usb clk
>>> is not found, it does not configure/enable it).
>>>
>>> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
>> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> I don't have the original, where is it ? Was it not Cced to linux-usb ?
> Can someone resend with Nicolas' Acked-by in place ?
>
This mail was sent to linux-usb@vger.kernel.org and to you (balbi@ti.com).
It may have been filtered.

Anyway, you asked me to rework the 2nd version (which I did).

I think it's better to review the 3rd one 
(https://lkml.org/lkml/2013/8/2/102).

Best Regards,

Boris
