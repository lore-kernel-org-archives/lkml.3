Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751173AbaK0Wgk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 17:36:40 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:54387 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbaK0Wgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 17:36:37 -0500
Date: Thu, 27 Nov 2014 23:34:02 +0100
From: Beniamino Galvani <b.galvani@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Carlo Caione <carlo@caione.org>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>
Subject: Re: [PATCH v3 2/3] pinctrl: add driver for Amlogic Meson SoCs
Message-ID: <20141127223402.GA11418@gmail.com>
References: <1416168856-12747-1-git-send-email-b.galvani@gmail.com>
 <1416168856-12747-3-git-send-email-b.galvani@gmail.com>
 <CACRpkda-U5OuKdBVGJ8UWprJkAtmTL1m11+AbNskVULPfyS72A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkda-U5OuKdBVGJ8UWprJkAtmTL1m11+AbNskVULPfyS72A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 02:48:31PM +0100, Linus Walleij wrote:
> On Sun, Nov 16, 2014 at 9:14 PM, Beniamino Galvani <b.galvani@gmail.com> wrote:
> 
> > This is a driver for the pinmux and GPIO controller available in
> > Amlogic Meson SoCs. At the moment it only supports Meson8 devices,
> > however other SoC families like Meson6 and Meson8b (the Cortex-A5
> > variant) appear to be similar, with just different sets of banks and
> > registers.
> >
> > GPIO interrupts are not supported at the moment due to lack of
> > documentation.
> >
> > Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
> 
> This is dependent on Sören's patches I guess?
> 
> OK I'll merge this once we have that other code sorted out.

Yes, this depends on Soren's patches.

Thanks,
Beniamino
