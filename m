Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab3FPKRb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 06:17:31 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:49260 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899Ab3FPKRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 06:17:30 -0400
MIME-Version: 1.0
In-Reply-To: <51BB3A2C.608@wwwdotorg.org>
References: <1370980749-15383-1-git-send-email-linus.walleij@stericsson.com>
	<51BA1FE7.4000900@wwwdotorg.org>
	<CACRpkdZV7R3MgbuvEMhs24YYv2hK8Kt9Kjmv_cpRQQ1NYviDQg@mail.gmail.com>
	<51BB3A2C.608@wwwdotorg.org>
Date: Sun, 16 Jun 2013 12:17:29 +0200
Message-ID: <CACRpkdbmv4abXiYZEpN7BsV+H1aafm+tQV4r8bFWYVKtFDQZMg@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: document the pinctrl PM states
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Warren <swarren@nvidia.com>, Kevin Hilman <khilman@linaro.org>,
        Tony Lindgren <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 5:43 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 06/13/2013 02:34 PM, Linus Walleij wrote:
>> On Thu, Jun 13, 2013 at 9:39 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>>> On 06/11/2013 01:59 PM, Linus Walleij wrote:
>>>> From: Linus Walleij <linus.walleij@linaro.org>
>>>>
>>>> This document snippet tries to be helpful and define the pin
>>>> PM states and helpers, and how they should be used to create
>>>> some kind of common ontology around this.
>>>
>>> Oops. I haven't been keeping up well. I propose we hold off on this
>>> patch for a short while until the other thread on this topic is finalized.
>>
>> Isn't it better if I split it?
>>
>> Most of this doc is about the default/sleep/idle states and
>> how that relates to runtime PM, and that seems to be
>> uncontroversial.
>
> I would tend to prefer sorting out the issue fully, then documenting it
> once. This avoids churn.

OK I've pulled out this patch for now.

Yours,
Linus Walleij
