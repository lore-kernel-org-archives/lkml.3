Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965302Ab3BNRly (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 12:41:54 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:61523 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934487Ab3BNRlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 12:41:52 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18Sp0XM/eUTNicRT+WlJ4p9
Date: Thu, 14 Feb 2013 09:41:48 -0800
From: Tony Lindgren <tony@atomide.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "Kumar, Anil" <anilkumar.v@ti.com>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        b-cousson@ti.com
Subject: Re: [PATCH] pinctrl: pinctrl-single: fix the binding documentation
Message-ID: <20130214174147.GD7144@atomide.com>
References: <1360550763-5404-1-git-send-email-anilkumar.v@ti.com>
 <CACRpkdYGQ3S8-Zfmm8gSU4-R1pr7AZgadRJqSa2diigt4WWpjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYGQ3S8-Zfmm8gSU4-R1pr7AZgadRJqSa2diigt4WWpjA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Walleij <linus.walleij@linaro.org> [130212 04:16]:
> On Mon, Feb 11, 2013 at 3:46 AM, Kumar, Anil <anilkumar.v@ti.com> wrote:
> 
> > As there are no use of #address-cells and #size-cells properties
> > in pinctrl-single driver DT node. Fix pinctrl-single binding documentation
> > to remove these properties.
> >
> > Signed-off-by: Kumar, Anil <anilkumar.v@ti.com>
> > ---
> > Tested on da850 EVM.
> 
> I need Tony Lindgrens ACK on this before I apply it.

No thanks, this driver is supposed to be generic and I would
not be surprised if it eventually will be used on some 64-bit
system. See "5) Required nodes and properties" in file
Documentation/devicetree/booting-without-of.txt.

Regards,

Tony
