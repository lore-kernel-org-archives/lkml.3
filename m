Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386AbaA2KVX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 05:21:23 -0500
Received: from 19.mo3.mail-out.ovh.net ([178.32.98.231]:54688 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750970AbaA2KVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 05:21:22 -0500
Message-ID: <52E8D5FA.9070400@overkiz.com>
Date: Wed, 29 Jan 2014 11:20:42 +0100
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-mtd@lists.infradead.org, dev@linux-sunxi.org
Subject: Re: [RFC PATCH 0/9] mtd: nand: add sunxi NAND Flash Controller support
References: <1389190924-26226-1-git-send-email-b.brezillon@overkiz.com>	<52D1494E.9090303@overkiz.com> <CAL_JsqJNd_gtn-cCLbZxT=s5NkkXp0DZkJkZrBhWiaL6Js=woQ@mail.gmail.com>
In-Reply-To: <CAL_JsqJNd_gtn-cCLbZxT=s5NkkXp0DZkJkZrBhWiaL6Js=woQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 15373318804333951196
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -51
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrieegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenogfuuhhsphgvtghtffhomhgrihhnucdlgeelmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -51
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrieegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenogfuuhhsphgvtghtffhomhgrihhnucdlgeelmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rob,

On 23/01/2014 16:22, Rob Herring wrote:
> On Sat, Jan 11, 2014 at 7:38 AM, boris brezillon
> <b.brezillon@overkiz.com> wrote:
>> On 08/01/2014 15:21, Boris BREZILLON wrote:
>>> Hello,
>>>
>>> This series add the sunxi NFC support with up to 8 NAND chip connected.
>>> I'm still in the early stages drivers development and some key features
>>> are
>>> missing, but it's usable (I tested it on the cubietruck board).
>>>
>>> Here's what's missing:
>>>    - HW ECC support
>>>    - DMA support
>>>    - HW randomization support
>>>    - many more improvements
>>>
>>> This series depends on Emilio's patch series implementing mod0 clks
>>>
>>> (http://lists.infradead.org/pipermail/linux-arm-kernel/2013-July/185478.html)
>>> + an other patch not yet posted
>>>
>>> (http://git.elopez.com.ar/linux/commits/5b4eb3ac406b9c98965714d40e8dd6da943d1ab0)
>>
>> During my reasearch regarding the HW ECC and HW randomizer of the Allwinner
>> NAND flash controller I found this document describing the Altera NAND flash
>> controller
>> (which is in turn based on a cadence IP):
> Which may be similar to drivers/mtd/nand/denali.c as Cadence bought Denali?
Actually I was wrong, the sunxi and the cadence IP have nothing in common.
This was pointed out by Henrik (see this thread :
https://groups.google.com/forum/#!searchin/linux-sunxi/nand/linux-sunxi/x69tFBi95Zk/bNyJlWWOV8oJ 
<https://groups.google.com/forum/#%21searchin/linux-sunxi/nand/linux-sunxi/x69tFBi95Zk/bNyJlWWOV8oJ>).


Sorry for the false hopes.

Best Regards,

Boris

>
> Rob

