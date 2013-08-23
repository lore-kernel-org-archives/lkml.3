Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab3HWXjA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 19:39:00 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:43218 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755252Ab3HWXi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 19:38:57 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] gpio: pcf857x: Add OF support
Date: Sat, 24 Aug 2013 01:40:13 +0200
Message-ID: <1519389.gne8KHTcP5@avalon>
User-Agent: KMail/4.10.5 (Linux/3.8.13-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CACRpkdYvP6yCiQMQFpzaerrcvFug4rNWALPSDvkTidmz8_PovQ@mail.gmail.com>
References: <1376953494-9684-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1376953494-9684-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <CACRpkdYvP6yCiQMQFpzaerrcvFug4rNWALPSDvkTidmz8_PovQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Friday 23 August 2013 19:54:03 Linus Walleij wrote:
> On Tue, Aug 20, 2013 at 1:04 AM, Laurent Pinchart wrote:
> > Add DT bindings for the pcf857x-compatible chips and parse the device
> > tree node in the driver.
> > 
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> 
> I'm holding this until I get some reaction from the device tree reviewers,
> or until I get unpatient, whichever comes first.

Will you get unpatient before the end of the v3.12 merge window ? ;-)

> It looks good to me.

Thanks.

-- 
Regards,

Laurent Pinchart

