Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758765Ab3EWTAx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 15:00:53 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:35886 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757828Ab3EWTAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 15:00:52 -0400
MIME-Version: 1.0
In-Reply-To: <20130424155547.GA4623@gmail.com>
References: <1366801122-13302-1-git-send-email-lee.jones@linaro.org>
	<20130424155547.GA4623@gmail.com>
Date: Thu, 23 May 2013 21:00:51 +0200
Message-ID: <CACRpkdbr4Lm4NGHzX4TTq4fYwFahwC82fQSBg_V=SGVKkqFdUg@mail.gmail.com>
Subject: Re: [PATCH v2] mmc: mmci: Allow MMCI to request channels with
 information acquired from DT
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Russell King <linux@arm.linux.org.uk>, Chris Ball <cjb@laptop.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 5:55 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Currently, if DMA information isn't passed from platform data, then DMA
> will not be used. This patch allows DMA information obtained though Device
> Tree to be used as well.
>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Chris Ball <cjb@laptop.org>
> Cc: linux-mmc@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

I've now tested this v2 version with device tree on Nomadik and
U300 and it works like a charm.
Tested-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
