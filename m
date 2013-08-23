Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081Ab3HWRyH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 13:54:07 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:63707 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905Ab3HWRyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 13:54:05 -0400
MIME-Version: 1.0
In-Reply-To: <1376953494-9684-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1376953494-9684-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
	<1376953494-9684-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Date: Fri, 23 Aug 2013 19:54:03 +0200
Message-ID: <CACRpkdYvP6yCiQMQFpzaerrcvFug4rNWALPSDvkTidmz8_PovQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] gpio: pcf857x: Add OF support
From: Linus Walleij <linus.walleij@linaro.org>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 1:04 AM, Laurent Pinchart
<laurent.pinchart+renesas@ideasonboard.com> wrote:

> Add DT bindings for the pcf857x-compatible chips and parse the device
> tree node in the driver.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

I'm holding this until I get some reaction from the device tree reviewers,
or until I get unpatient, whichever comes first. It looks good to me.

Yours,
Linus Walleij
