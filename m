Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323AbaEILuU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 07:50:20 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:57835 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515AbaEILuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 07:50:19 -0400
MIME-Version: 1.0
In-Reply-To: <1398438606-19718-2-git-send-email-thierry.reding@gmail.com>
References: <1398438606-19718-1-git-send-email-thierry.reding@gmail.com>
	<1398438606-19718-2-git-send-email-thierry.reding@gmail.com>
Date: Fri, 9 May 2014 13:50:18 +0200
Message-ID: <CACRpkdaGHviAXxLYcsMu2Jc+3zE_Wmm275YGYEo=U7CNk8dzUg@mail.gmail.com>
Subject: Re: [PATCH 2/2] gpio: Add helpers for optional GPIOs
From: Linus Walleij <linus.walleij@linaro.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 5:10 PM, Thierry Reding
<thierry.reding@gmail.com> wrote:

> From: Thierry Reding <treding@nvidia.com>
>
> Introduce gpiod_get_optional() and gpiod_get_index_optional() helpers
> that make it easier for drivers to handle optional GPIOs.

Excellent Thierry, patch applied with Alexandre's review tag.

Can you *please* also produce a patch to
Documentation/gpio/consumer.txt
explaining the new interface to potential users?

Yours,
Linus Walleij
