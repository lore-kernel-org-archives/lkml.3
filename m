Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152Ab3DYLjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 07:39:09 -0400
Received: from mail-ia0-f176.google.com ([209.85.210.176]:41435 "EHLO
	mail-ia0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185Ab3DYLjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 07:39:07 -0400
MIME-Version: 1.0
In-Reply-To: <1366279934-30761-29-git-send-email-lee.jones@linaro.org>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
	<1366279934-30761-29-git-send-email-lee.jones@linaro.org>
Date: Thu, 25 Apr 2013 13:39:06 +0200
Message-ID: <CACRpkdYrpxt0DZutX=XhYUoj112+m26h60WO-Yf8BOo+ONfNHw@mail.gmail.com>
Subject: Re: [PATCH 28/32] ARM: ux500: Pass remnant platform data though to
 DMA40 driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 12:12 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Ironically, in order to remove lots of the auxdata assignments, we have
> to add just one more. A lot of them require DMA information to be passed
> into clients for DMA channel allocation, but we now have this capability
> in Device Tree. However, the DMA40 driver still relies on a reverse table
> look-up to obtain DMA addresses. Until all of the clients are converted,
> over to the new API, we're stuck with this.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

As mentioned merge into patch 27, then ACK.

Yours,
Linus Walleij
