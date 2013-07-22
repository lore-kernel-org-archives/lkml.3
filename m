Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275Ab3GVXAF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 19:00:05 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:34172 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab3GVXAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 19:00:02 -0400
MIME-Version: 1.0
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E030458DDC71C@US01WEMBX2.internal.synopsys.com>
References: <38175373.Cq6zxae9tO@harkonnen> <A2CA0424C0A6F04399FB9E1CD98E030458DDC71C@US01WEMBX2.internal.synopsys.com>
From: Federico Vaga <federico.vaga@gmail.com>
Date: Tue, 23 Jul 2013 00:59:40 +0200
Message-ID: <CAH5GJ0rB8p2doS3AZ_ywoY8nWmD8Vnjd+jCAxt06U021SB7YLQ@mail.gmail.com>
Subject: Re: DWC2 and/or S3C-HSOTG for STA2X11 board
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Sorry for the delayed answer :(

> As part of the merge, we will need to develop a PCI wrapper for
> s3c-hsotg anyway, so I think it would not be wasted effort.
> Actually, as a POC I already did this as a quick hack, just to
> make sure that the driver will work on our PCIe prototyping
> platform (it does).
>
> As Felipe says, currently s3c-hsotg does have too much knowledge
> of Samsung platform. But it should be fairly easy to move that
> knowledge from the core code to a platform-device wrapper,
> similar to platform.c in the dwc2 driver. So if you would like
> to work on that (creating a PCI wrapper and a platform wrapper)
> I think it would be useful.
>
> If you want, I can send you my hacked-up code for the PCI
> version of the driver, to use as a starting point.

Yes, it will be really useful, thanks.

I will try to do both wrapper (PCI, platform), but I do not know how much
time does it takes because I am really busy at the moment

You know the hardware better than me, so: have you other suggestion
to point me on the right way?

Thank you :)

--
Federico Vaga
