Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbaHUNfN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 09:35:13 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:63793 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340AbaHUNfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 09:35:10 -0400
MIME-Version: 1.0
In-Reply-To: <1408381705-3623-1-git-send-email-abrestic@chromium.org>
References: <1408381705-3623-1-git-send-email-abrestic@chromium.org>
From: Tomeu Vizoso <tomeu@tomeuvizoso.net>
Date: Thu, 21 Aug 2014 15:34:48 +0200
X-Google-Sender-Auth: 31mTLjVp8mp0WmQyMJ3tthY0X5A
Message-ID: <CAAObsKDT4BV=fGAFkMxieQnC3HX=zm8G_qJ44yay4qG8inxoPQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/9] Tegra xHCI support
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>, linux-tegra@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        linux-usb@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jassi Brar <jassisinghbrar@gmail.com>, linux-kernel@vger.kernel.org,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 August 2014 19:08, Andrew Bresticker <abrestic@chromium.org> wrote:
>
> Tested on Venice2, Jetson TK1, and Big with a variety of USB2.0 and
> USB3.0 memory sticks and ethernet dongles using controller firmware from
> the ChromiumOS tree [2].

Hi Andrew,

do you have any information regarding the port assignments for the
Blaze board? Would like to test this there.

Thanks,

Tomeu
