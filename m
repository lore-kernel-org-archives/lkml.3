Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947122Ab3BHWFq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 17:05:46 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:43926 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946953Ab3BHWFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 17:05:45 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] devicetree: Move NS2 LEDs binding into LEDs directory
To: Jason Cooper <jason@lakedaemon.net>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Andrew Lunn <andrew@lunn.ch>, Simon Guinot <simon.guinot@sequanux.org>
In-Reply-To: <20130207132118.GE14746@titan.lakedaemon.net>
References: <1360239776-14889-1-git-send-email-grant.likely@secretlab.ca> <20130207132118.GE14746@titan.lakedaemon.net>
Date: Fri, 08 Feb 2013 22:05:41 +0000
Message-Id: <20130208220541.5DDDD3E2C27@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Feb 2013 08:21:18 -0500, Jason Cooper <jason@lakedaemon.net> wrote:
> On Thu, Feb 07, 2013 at 12:22:56PM +0000, Grant Likely wrote:
> > leds-ns2.txt is a binding for LEDs, not GPIOs. Move the documentation in
> > with the rest of the LEDs bindings.
> > 
> > Cc: Andrew Lunn <andrew@lunn.ch>
> > Cc: Simon Guinot <simon.guinot@sequanux.org>
> > Cc: Jason Cooper <jason@lakedaemon.net>
> > Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> > ---
> >  .../devicetree/bindings/gpio/leds-ns2.txt          |   26 --------------------
> >  .../devicetree/bindings/leds/leds-ns2.txt          |   26 ++++++++++++++++++++
> >  2 files changed, 26 insertions(+), 26 deletions(-)
> >  delete mode 100644 Documentation/devicetree/bindings/gpio/leds-ns2.txt
> >  create mode 100644 Documentation/devicetree/bindings/leds/leds-ns2.txt
> 
> Acked-by: Jason Cooper <jason@lakedaemon.net>
> 
> or, if you want, I can queue it up.  Just let me know.

No, I got it. It was trivial so I committed it directly without waiting
for review comments.

g.
