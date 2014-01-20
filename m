Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbaATOtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 09:49:18 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:54269 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbaATOtM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 09:49:12 -0500
MIME-Version: 1.0
In-Reply-To: <2229282.4AAJ7iLdU7@phil>
References: <201312201626.48119.heiko@sntech.de>
	<2229282.4AAJ7iLdU7@phil>
Date: Mon, 20 Jan 2014 08:49:11 -0600
Message-ID: <CAL_JsqLwsJkCbu7rZDGTquryFzom4K4hg3GrczifbAV+pvpcaQ@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: add rockchip vendor prefix
From: Rob Herring <robherring2@gmail.com>
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: Rob Herring <robh+dt@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arm@kernel.org" <arm@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 8:23 AM, Heiko Stübner <heiko@sntech.de> wrote:
> Am Freitag, 20. Dezember 2013, 16:26:47 schrieb Heiko Stübner:
>> It seems I forgot to add the vendor prefix for rockchip to the vendor-prefix
>> list. Therefore add it now.
>>
>> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
>
> not sure, where this should go through
> arm-soc? or is there a special dt-tree around?

Sorry, missed this one. I'll apply for 3.14.

Rob

>
>
> Thanks
> Heiko
>
>> ---
>>  Documentation/devicetree/bindings/vendor-prefixes.txt |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt
>> b/Documentation/devicetree/bindings/vendor-prefixes.txt index
>> ca2c190..2dc3b75 100644
>> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
>> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
>> @@ -65,6 +65,7 @@ ralink      Mediatek/Ralink Technology Corp.
>>  ramtron      Ramtron International
>>  realtek Realtek Semiconductor Corp.
>>  renesas      Renesas Electronics Corporation
>> +rockchip     Fuzhou Rockchip Electronics Co., Ltd
>>  samsung      Samsung Semiconductor
>>  sbs  Smart Battery System
>>  schindler    Schindler
>
