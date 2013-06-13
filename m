Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759245Ab3FMUeM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 16:34:12 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:36496 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757659Ab3FMUeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 16:34:11 -0400
MIME-Version: 1.0
In-Reply-To: <51BA1FE7.4000900@wwwdotorg.org>
References: <1370980749-15383-1-git-send-email-linus.walleij@stericsson.com>
	<51BA1FE7.4000900@wwwdotorg.org>
Date: Thu, 13 Jun 2013 22:34:10 +0200
Message-ID: <CACRpkdZV7R3MgbuvEMhs24YYv2hK8Kt9Kjmv_cpRQQ1NYviDQg@mail.gmail.com>
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

On Thu, Jun 13, 2013 at 9:39 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 06/11/2013 01:59 PM, Linus Walleij wrote:
>> From: Linus Walleij <linus.walleij@linaro.org>
>>
>> This document snippet tries to be helpful and define the pin
>> PM states and helpers, and how they should be used to create
>> some kind of common ontology around this.
>
> Oops. I haven't been keeping up well. I propose we hold off on this
> patch for a short while until the other thread on this topic is finalized.

Isn't it better if I split it?

Most of this doc is about the default/sleep/idle states and
how that relates to runtime PM, and that seems to be
uncontroversial.

Yours,
Linus Walleij
