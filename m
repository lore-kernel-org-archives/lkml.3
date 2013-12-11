Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751407Ab3LKS17 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 13:27:59 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:61126 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab3LKS15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 13:27:57 -0500
MIME-Version: 1.0
In-Reply-To: <20131211160440.GA13171@atomide.com>
References: <1386757305-12545-1-git-send-email-nm@ti.com>
	<1386757305-12545-2-git-send-email-nm@ti.com>
	<20131211160440.GA13171@atomide.com>
Date: Wed, 11 Dec 2013 12:27:55 -0600
X-Google-Sender-Auth: 0pZW8ZdgWr69_wlad8i-rjFyKFE
Message-ID: <CAGo_u6oHPJSfDF=9WVTb2ukmwxDoasho=4L7qJmnYng6-84N0Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] net: smc91x: Read hardware behavior flags from device tree
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>
Cc: dt list <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        netdev@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 10:04 AM, Tony Lindgren <tony@atomide.com> wrote:
> * Nishanth Menon <nm@ti.com> [131211 02:23]:
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/smsc91x.txt
>> @@ -0,0 +1,45 @@
>> +* Smart Mixed-Signal Connectivity (SMSC) LAN91c94/91c111 Controller
>> +
>> +Required properties:
>> +- compatible : Should be one of:
>> +     "smsc,lan91c94"
>> +     "smsc,lan91c111"
>> +- reg : Address and length of the io space for SMSC LAN
>> +- interrupts : Should contain SMSC LAN interrupt line
>> +- interrupt-parent : Should be the phandle for the interrupt controller
>> +  that services interrupts for this device
>> +
>> +Optional properties:
>> +- reg-shift : Specify the quantity to shift the register offsets by
>> +- reg-io-width : Specify the size (in bytes) of the IO accesses that
>> +  should be performed on the device.  Valid value for SMSC LAN is
>> +  1, 2 or 4.
>
> I posted a minimal regression fix for this a few weeks ago that we
> should merge to the v3.13-rc cycle:
>
> http://www.spinics.net/lists/netdev/msg258913.html
>
> Care to ack that one?
Done.

> Then if that works for you, maybe rebase these on
> that one for the upcoming merge window?
it seems like omap is the only folks who are currently using this
driver in dt form, I kinda proposed to do these as add on changes to
your patch, lets see if anyone cares about it.

but I agree to drop my series at this point,

Regards,
Nishanth Menon
