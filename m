Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbaIHQWP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 12:22:15 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:42774 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186AbaIHQWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 12:22:12 -0400
MIME-Version: 1.0
In-Reply-To: <CAAObsKAYqpJMJnxSMxhkkRtnoEwLwgUa1y7ij5ZHvHf1jRok+Q@mail.gmail.com>
References: <1409693701-16520-1-git-send-email-abrestic@chromium.org>
	<CAAObsKAYqpJMJnxSMxhkkRtnoEwLwgUa1y7ij5ZHvHf1jRok+Q@mail.gmail.com>
Date: Mon, 8 Sep 2014 09:22:11 -0700
X-Google-Sender-Auth: BqckmX7oJ5X8M8KqAhhnx-juCaI
Message-ID: <CAL1qeaF7U9aoBp5gQPS=r+pe6krKmXdP1qak2gjhNqQMoHFB8A@mail.gmail.com>
Subject: Re: [PATCH v3 0/9] Tegra xHCI support
From: Andrew Bresticker <abrestic@chromium.org>
To: Tomeu Vizoso <tomeu@tomeuvizoso.net>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 8, 2014 at 8:34 AM, Tomeu Vizoso <tomeu@tomeuvizoso.net> wrote:
> On 2 September 2014 23:34, Andrew Bresticker <abrestic@chromium.org> wrote:
>>
>> Tested on Venice2, Jetson TK1, and Big with a variety of USB2.0 and
>> USB3.0 memory sticks and ethernet dongles using controller firmware
>> recently posted by Andrew Chew [2].
>
> I have had mixed results when testing this on a Jetson TK1 board. Of 8
> USB devices I tested with, about half where probed correctly, but the
> other half repeatedly fail in hub_port_init because in the GET_STATUS
> right after the reset, the C_PORT_CONNECTION bit is set.
>
> I don't see any correlation between the failure and the kind of usb
> device, but I don't have much experience with USB implementations
> either.

Hmm... I haven't seen that before.  Which particular devices were you using?
