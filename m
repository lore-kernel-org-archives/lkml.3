Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706Ab3FXUpE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 16:45:04 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:64669 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab3FXUpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 16:45:02 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <1372106517-19105-1-git-send-email-dianders@chromium.org>
References: <1372106517-19105-1-git-send-email-dianders@chromium.org>
Date: Mon, 24 Jun 2013 13:45:01 -0700
Message-ID: <CAOesGMgqr6f1wwD5JWzMoQWkMpQDWXhadRtJMvKr1RC6RD9RgA@mail.gmail.com>
Subject: Re: [PATCH] ARM: Fix dtb dependency to use order-only prerequisites
From: Olof Johansson <olof@lixom.net>
To: Doug Anderson <dianders@chromium.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 1:41 PM, Doug Anderson <dianders@chromium.org> wrote:
> The %.dtb dependency is specified to depend on the PHONY "scripts".
> That means that it'll build every time even if the underlying dtb file
> hasn't been touched.  Use an order-only prerequisites to fix this.
> Also mark "dtbs" as PHONY for correctness.
>
> This was broken in (70b0476 ARM: 7513/1: Make sure dtc is built before
> running it).
>
> Reported-by: Mike Frysinger <vapier@gentoo.org>
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Acked-by: Olof Johansson <olof@lixom.net>

Please send to Russell's patch tracker.


-Olof
