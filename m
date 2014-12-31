Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608AbaLaU40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 15:56:26 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:48286 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbaLaU4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 15:56:24 -0500
MIME-Version: 1.0
In-Reply-To: <1418302951-9309-3-git-send-email-octavian.purdila@intel.com>
References: <1418302951-9309-1-git-send-email-octavian.purdila@intel.com>
	<1418302951-9309-3-git-send-email-octavian.purdila@intel.com>
Date: Wed, 31 Dec 2014 21:56:24 +0100
Message-ID: <CACRpkdZq4r+3yLvumxM-+f-VyMCb-ZF8xE7_kOx7uAoxrPzpTw@mail.gmail.com>
Subject: Re: [PATCH 2/3] gpio: dln2: use bus_sync_unlock instead of scheduling work
From: Linus Walleij <linus.walleij@linaro.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: Lee Jones <lee.jones@linaro.org>, Johan Hovold <johan@kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 2:02 PM, Octavian Purdila
<octavian.purdila@intel.com> wrote:

> Use the irq_chip bus_sync_unlock method to update hardware registers
> instead of scheduling work from the mask/unmask methods. This simplifies
> a bit the driver and make it more uniform with the other GPIO IRQ
> drivers.
>
> Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>

Patch applied for fixes.

Yours,
Linus Walleij
