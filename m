Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab3JBKvB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 06:51:01 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:43005 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532Ab3JBKu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 06:50:59 -0400
MIME-Version: 1.0
In-Reply-To: <1380484837-27668-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1380484837-27668-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Date: Wed, 2 Oct 2013 12:50:58 +0200
Message-ID: <CACRpkdbF+8rYxSbSQLoRo-pEmZvc1mduT5kMAsXYE2pQHPsPrQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: arizona: Use the of_node from the Arizona device
From: Linus Walleij <linus.walleij@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: Mark Brown <broonie@kernel.org>, patches@opensource.wolfsonmicro.com,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 29, 2013 at 10:00 PM, Charles Keepax
<ckeepax@opensource.wolfsonmicro.com> wrote:

> We need to use the of_node from the main Arizona device as that
> holds our configuration.
>
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

Patch applied.

Yours,
Linus Walleij
