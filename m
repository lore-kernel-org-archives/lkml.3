Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386AbaEXTUM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 15:20:12 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:36034 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaEXTUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 15:20:10 -0400
Message-ID: <5380F0E3.7020008@gmail.com>
Date: Sat, 24 May 2014 21:20:03 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Marek Vasut <marex@denx.de>, linux-arm-kernel@lists.infradead.org
CC: mark.rutland@arm.com, devicetree@vger.kernel.org, linux@arm.linux.org.uk,
        herbert@gondor.apana.org.au, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, rdunlap@infradead.org,
        linux-kernel@vger.kernel.org, robh+dt@kernel.org,
        LABBE Corentin <clabbe.montjoie@gmail.com>,
        linux-crypto@vger.kernel.org, galak@codeaurora.org,
        grant.likely@linaro.org, maxime.ripard@free-electrons.com,
        davem@davemloft.net
Subject: Re: [PATCH 1/3] dt: Add DT bindings documentation for SUNXI Security
 System
References: <1400771396-9686-1-git-send-email-clabbe.montjoie@gmail.com> <1400771396-9686-2-git-send-email-clabbe.montjoie@gmail.com> <201405241321.32147.marex@denx.de>
In-Reply-To: <201405241321.32147.marex@denx.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marek,

On 24.05.2014 13:21, Marek Vasut wrote:
> On Thursday, May 22, 2014 at 05:09:54 PM, LABBE Corentin wrote:
> 
> Missing commit message. Please fix this and send a V2.
> 
>> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
>> ---
>>  Documentation/devicetree/bindings/crypto/sunxi-ss.txt | 9 +++++++++
>>  1 file changed, 9 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/crypto/sunxi-ss.txt
>>
>> diff --git a/Documentation/devicetree/bindings/crypto/sunxi-ss.txt
>> b/Documentation/devicetree/bindings/crypto/sunxi-ss.txt new file mode
>> 100644
>> index 0000000..356563b
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/crypto/sunxi-ss.txt
>> @@ -0,0 +1,9 @@
>> +* Allwinner Security System found on A20 SoC
>> +
>> +Required properties:
>> +- compatible : Should be "allwinner,sun7i-a20-crypto".
> 
> Why sun7i-a20 ? Is the crypto unit different in other sunxi chips ? Can that not 
> be described by DT props ?

A widely used convention is to define compatible strings after first
SoCs on which particular IP blocks appear. It is quite common among IP
blocks for which there is no well defined versioning scheme.

Best regards,
Tomasz
