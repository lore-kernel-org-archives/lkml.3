Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195Ab3FROvE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 10:51:04 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:35220 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755685Ab3FROux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 10:50:53 -0400
MIME-Version: 1.0
In-Reply-To: <1371546267-22093-1-git-send-email-sachin.kamat@linaro.org>
References: <1371546267-22093-1-git-send-email-sachin.kamat@linaro.org>
Date: Tue, 18 Jun 2013 16:50:52 +0200
Message-ID: <CACRpkdafkPoicyR+QjZfkcyatqcWND=LdLgWpBZKK_5JC1WrVg@mail.gmail.com>
Subject: Re: [PATCH 1/4] pinctrl: bcm2835: Staticize bcm2835_gpio_pins
From: Linus Walleij <linus.walleij@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 11:04 AM, Sachin Kamat <sachin.kamat@linaro.org> wrote:

> 'bcm2835_gpio_pins' is used only in this file.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Stephen Warren <swarren@wwwdotorg.org>

Patch applied.

Thanks,
Linus Walleij
