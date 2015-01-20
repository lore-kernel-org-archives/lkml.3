Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174AbbATCED (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 21:04:03 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:54775 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbbATCEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 21:04:01 -0500
MIME-Version: 1.0
In-Reply-To: <1421581173-28416-8-git-send-email-ricardo.ribalda@gmail.com>
References: <1421581173-28416-1-git-send-email-ricardo.ribalda@gmail.com> <1421581173-28416-8-git-send-email-ricardo.ribalda@gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 20 Jan 2015 11:03:40 +0900
Message-ID: <CAAVeFuLHThCVmh4wjUP5_PZLVS6aqjmx8p-w1zyTw2PXM1wC7g@mail.gmail.com>
Subject: Re: [PATCH 7/8] gpio/mpc8xxx: Convert to platform device interface.
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Peter Korsgaard <jacmet@sunsite.dk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2015 at 8:39 PM, Ricardo Ribalda Delgado
<ricardo.ribalda@gmail.com> wrote:
> This way we do not need to transverse the device tree manually.

... and this makes things much more legible.

Acked-by: Alexandre Courbot <acourbot@nvidia.com>
