Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457AbaJIPUH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 11:20:07 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:53998 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071AbaJIPT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 11:19:57 -0400
Message-ID: <5436A793.6090204@collabora.co.uk>
Date: Thu, 09 Oct 2014 17:19:47 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Mark Brown <broonie@kernel.org>, Doug Anderson <dianders@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 1/5] regulator: of: Add regulator-initial-mode parse support
References: <1412775847-15213-1-git-send-email-javier.martinez@collabora.co.uk> <1412775847-15213-2-git-send-email-javier.martinez@collabora.co.uk> <20141008142511.GA4609@sirena.org.uk> <54354C7D.7090104@collabora.co.uk> <20141008151220.GE4609@sirena.org.uk> <54356666.4090003@collabora.co.uk> <20141009102717.GG3869@leverpostej>
In-Reply-To: <20141009102717.GG3869@leverpostej>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark,

On 10/09/2014 12:27 PM, Mark Rutland wrote:
>> 
>> Well, is not fairly obvious to me. One can also say the opposite, why the
>> kernel is documenting a DT binding that is not (currently) implemented?
> 
> Checkpatch will complain regarding undocumented bindings, so from a
> pragmatic point of view the binding must come first.
>
> Personally, when I read a patch series I do an initial pass in-order,
> and having the binding first makes things clearer. I might have some
> questions regarding the binding that the driver answers later, and it makes it
> easier to spot undocumented properties or conventions used by the
> driver. Doing so the other way around usually leaves me with more
> questions at the end.
>

Thanks a lot for the explanation, it certainly makes sense then to have
the DT binding before. I'll propose a patch to add that information to
Documentation/devicetree/bindings/submitting-patches.txt so people
(like me) who didn't find it obvious can know what the convention is.
 
>> That's why what makes the most sense for me is what the old convention did,
>> add the DT binding docs in the same patch that implements the binding.
> 
> Having a separate patch for the binding is very helpful for those of us
> doing review. For one thing it helps us to find the binding document,
> which can be important when a driver is thousands of lines long. For
> another it means that we can be clear that our Acked-by, Reviewed-by,
> etc apply to the binding and not necessarily the rest of the code.
> 

Agreed.

> For small patches, this is obviously less of a concern.
> 
> Thanks,
> Mark.
> 

Best regards,
Javier
