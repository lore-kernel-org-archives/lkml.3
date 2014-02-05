Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667AbaBENeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 08:34:50 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:63632 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaBENes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 08:34:48 -0500
Message-ID: <52F23DF4.7010901@gmail.com>
Date: Wed, 05 Feb 2014 14:34:44 +0100
From: Boris BREZILLON <b.brezillon.dev@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
CC: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, dev@linux-sunxi.org,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, Pekon Gupta <pekon@ti.com>
Subject: Re: [RFC PATCH v2 03/14] of: mtd: add documentation for nand-ecc-level
 property
References: <1391006064-28890-1-git-send-email-b.brezillon.dev@gmail.com> < 1391006064-28890-4-git-send-email-b.brezillon.dev@gmail.com> < 20140129175331.GA27143@localhost> <20140205111500.B19FDC40A89@trevor.secretlab.ca>
In-Reply-To: <20140205111500.B19FDC40A89@trevor.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2014 12:15, Grant Likely wrote:
> On Wed, 29 Jan 2014 14:53:32 -0300, Ezequiel Garcia <ezequiel.garcia@free-electrons.com> wrote:
>> On Wed, Jan 29, 2014 at 03:34:13PM +0100, Boris BREZILLON wrote:
>>> nand-ecc-level property statically defines NAND chip's ECC requirements.
>>>
>>> Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
>>> ---
>>>   Documentation/devicetree/bindings/mtd/nand.txt |    3 +++
>>>   1 file changed, 3 insertions(+)
>>>
>>> diff --git a/Documentation/devicetree/bindings/mtd/nand.txt b/Documentation/devicetree/bindings/mtd/nand.txt
>>> index 03855c8..0c962296 100644
>>> --- a/Documentation/devicetree/bindings/mtd/nand.txt
>>> +++ b/Documentation/devicetree/bindings/mtd/nand.txt
>>> @@ -3,5 +3,8 @@
>>>   - nand-ecc-mode : String, operation mode of the NAND ecc mode.
>>>     Supported values are: "none", "soft", "hw", "hw_syndrome", "hw_oob_first",
>>>     "soft_bch".
>>> +- nand-ecc-level : Two cells property defining the ECC level requirements.
>>> +  The first cell represent the strength and the second cell the ECC block size.
>>> +  E.g. : nand-ecc-level = <4 512>; /* 4 bits / 512 bytes */
>>>   - nand-bus-width : 8 or 16 bus width if not present 8
>>>   - nand-on-flash-bbt: boolean to enable on flash bbt option if not present false
>> Hm.. when was this proposal agreed? It seems I've missed the
>> discussion...
>>
>> FWIW, we've already proposed an equivalent one, but it received no
>> feedback from the devicetree maintainers:
> Sorry, binding review has become a huge undertaking.
>
>> http://comments.gmane.org/gmane.linux.drivers.devicetree/58764
>>
>> Maybe we can discuss about it now?
>>
>>    nand-ecc-strength : integer ECC required strength.
>>    nand-ecc-size : integer step size associated to the ECC strength.
> I'm okay with either, but the above binding is indeed more readable.

That's fine by me, if everybody agrees, let's go for the
nand-ecc-strength/nand-ecc-size couple then.

I'll rebase next version of my series on Ezequiel's patch providing
these OF helpers.

Best Regards,

Boris

>
> g.

