Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247Ab3DYNNF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 09:13:05 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:59624 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755629Ab3DYNND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 09:13:03 -0400
MIME-Version: 1.0
In-Reply-To: <1366729394-11406-8-git-send-email-lee.jones@linaro.org>
References: <1366729394-11406-1-git-send-email-lee.jones@linaro.org>
	<1366729394-11406-8-git-send-email-lee.jones@linaro.org>
Date: Thu, 25 Apr 2013 15:13:02 +0200
Message-ID: <CACRpkdYK0W4wLGSK9akY7Ji4j8EUW=XwO8GCHpkXuLbP-aZW1w@mail.gmail.com>
Subject: Re: [PATCH 07/10] ARM: ux500: Add an auxdata entry for MUSB for
 clock-name look-up
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 5:03 PM, Lee Jones <lee.jones@linaro.org> wrote:

> The recently DT:ed MUSB driver will require clock-name by device-name
> look-up capability, until common clk has is properly supported by the
> ux500 platform.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
