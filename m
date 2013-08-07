Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933021Ab3HGTyz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 15:54:55 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:60967 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932348Ab3HGTyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 15:54:54 -0400
MIME-Version: 1.0
In-Reply-To: <5202A2EC.2070907@wwwdotorg.org>
References: <1375739760-18833-1-git-send-email-swarren@wwwdotorg.org>
	<CACRpkdb1qSO2OhFebgAPESAzRySaCyQcBH97s4E7+F-3wmXZpw@mail.gmail.com>
	<5202A2EC.2070907@wwwdotorg.org>
Date: Wed, 7 Aug 2013 21:54:53 +0200
Message-ID: <CACRpkdb2sORvPW+wy3BO-+ZXnMOk2Vsw13VL7Kp4_WKS3yxhDA@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: clean up pinconfig-generic documentation
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Pawel Moll <pawel.moll@arm.com>, Rob Herring <rob.herring@calxeda.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 7, 2013 at 9:41 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 08/07/2013 01:32 PM, Linus Walleij wrote:
>> On Mon, Aug 5, 2013 at 11:55 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>>
>>> From: Stephen Warren <swarren@nvidia.com>
>>>
>>> Reword the section of pinctrl-bindings.txt that describes generic
>>> properties that pinctrl bindings may use. The aim is to make the text
>>> clearer, and more explicitly call out the responsibility of individual
>>> bindings that use the generic properties to define which of the
>>> properties are used, and how.
>>>
>>> Signed-off-by: Stephen Warren <swarren@nvidia.com>
>>> ---
>>> LinusW, Laxman, this is the binding doc cleanup I mentioned I was going
>>> to send when reviewing Laxman's Palmas pinctrl driver.
>>
>> Looks good to me.
>> Patch applied.
>
> I assume just patch 1? There was a v2 of patch 2.

Yes ... I haven't found that v2 of patch 2 yet.

Yours,
Linus Walleij
