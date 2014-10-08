Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771AbaJHQ3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 12:29:36 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:52666 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbaJHQ3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 12:29:34 -0400
Message-ID: <54356666.4090003@collabora.co.uk>
Date: Wed, 08 Oct 2014 18:29:26 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Doug Anderson <dianders@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 1/5] regulator: of: Add regulator-initial-mode parse support
References: <1412775847-15213-1-git-send-email-javier.martinez@collabora.co.uk> <1412775847-15213-2-git-send-email-javier.martinez@collabora.co.uk> <20141008142511.GA4609@sirena.org.uk> <54354C7D.7090104@collabora.co.uk> <20141008151220.GE4609@sirena.org.uk>
In-Reply-To: <20141008151220.GE4609@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2014 05:12 PM, Mark Brown wrote:
> On Wed, Oct 08, 2014 at 04:38:53PM +0200, Javier Martinez Canillas wrote:
>> On 10/08/2014 04:25 PM, Mark Brown wrote:
> 
>> > That doesn't mean that the definition of those modes is something we can
>> > sensibly provide in generic code, especially in a completely
>> > undocumented fashion (perhaps you've done that later in the patch series
>> > but bisection also applies to reviewability).
> 
>> As a general question, now that the convention is for DT binding docs to go
>> in a separate patch, should the DT documentation be added before or after
>> that code using these bindings is added?
> 
> It fairly obviously needs to go before so that reviewers can tell if the
> code is actually implementing the binding.
> 

Well, is not fairly obvious to me. One can also say the opposite, why the
kernel is documenting a DT binding that is not (currently) implemented?

That's why what makes the most sense for me is what the old convention did,
add the DT binding docs in the same patch that implements the binding.

Anyways, thanks for letting me know what is the convention today.
