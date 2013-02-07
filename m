Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758664Ab3BGNV1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 08:21:27 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:17173 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758233Ab3BGNV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 08:21:26 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/ivdnrjacTuO18FPKY8ohSMurBOgYoRDg=
Date: Thu, 7 Feb 2013 08:21:18 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Andrew Lunn <andrew@lunn.ch>, Simon Guinot <simon.guinot@sequanux.org>
Subject: Re: [PATCH] devicetree: Move NS2 LEDs binding into LEDs directory
Message-ID: <20130207132118.GE14746@titan.lakedaemon.net>
References: <1360239776-14889-1-git-send-email-grant.likely@secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360239776-14889-1-git-send-email-grant.likely@secretlab.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2013 at 12:22:56PM +0000, Grant Likely wrote:
> leds-ns2.txt is a binding for LEDs, not GPIOs. Move the documentation in
> with the rest of the LEDs bindings.
> 
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Simon Guinot <simon.guinot@sequanux.org>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
>  .../devicetree/bindings/gpio/leds-ns2.txt          |   26 --------------------
>  .../devicetree/bindings/leds/leds-ns2.txt          |   26 ++++++++++++++++++++
>  2 files changed, 26 insertions(+), 26 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/gpio/leds-ns2.txt
>  create mode 100644 Documentation/devicetree/bindings/leds/leds-ns2.txt

Acked-by: Jason Cooper <jason@lakedaemon.net>

or, if you want, I can queue it up.  Just let me know.

thx,

Jason.
