Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757747Ab3DYNBZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 09:01:25 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:62615 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756155Ab3DYNBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 09:01:24 -0400
MIME-Version: 1.0
In-Reply-To: <1366729394-11406-2-git-send-email-lee.jones@linaro.org>
References: <1366729394-11406-1-git-send-email-lee.jones@linaro.org>
	<1366729394-11406-2-git-send-email-lee.jones@linaro.org>
Date: Thu, 25 Apr 2013 15:01:23 +0200
Message-ID: <CACRpkdYs_dZoqfMFbXFPgWd2m4ssn8HO9QZf0+_01fM-YBcDrw@mail.gmail.com>
Subject: Re: [PATCH 01/10] usb: musb: ux500: move channel number knowledge
 into the driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>,
        Felipe Balbi <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Fabio Baltieri <fabio.baltieri@linaro.org>,
        Praveena Nadahally <praveen.nadahally@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that Fabio has written a few patches to this driver I'd like his help
in reviewing this series, can you make sure he gets a copy? Also
please include Praveena and Mian, thanks.

On Tue, Apr 23, 2013 at 5:03 PM, Lee Jones <lee.jones@linaro.org> wrote:

> For all ux500 based platforms the maximum number of end-points are used.
> Move this knowledge into the driver so we can relinquish the burden from
> platform data. This also removes quite a bit of complexity from the driver
> and will aid us when we come to enable the driver for Device Tree.
>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: linux-usb@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Looks good to me.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
