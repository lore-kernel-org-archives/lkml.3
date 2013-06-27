Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab3F0NPx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 09:15:53 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:36389 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab3F0NPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 09:15:51 -0400
MIME-Version: 1.0
In-Reply-To: <1372337887.8383.12.camel@cumari.coelho.fi>
References: <1372149330-24335-1-git-send-email-coelho@ti.com>
	<51CBC1C8.1040301@gmail.com>
	<1372322851.18889.53.camel@cumari.coelho.fi>
	<20130627125131.GA27285@kahuna>
	<1372337887.8383.12.camel@cumari.coelho.fi>
Date: Thu, 27 Jun 2013 08:15:49 -0500
X-Google-Sender-Auth: 4UcrCITyqIHR64P6kLTjO4ETaVE
Message-ID: <CAGo_u6qbt9dANgKq49xR=1qsCpUBhmVaPL4EK04XvTw+=4Z23g@mail.gmail.com>
Subject: Re: [PATCH] Documentation: dt: bindings: TI WiLink modules
From: Nishanth Menon <nm@ti.com>
To: Luciano Coelho <coelho@ti.com>
Cc: grant.likely@linaro.org, rob.herring@calxeda.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        linux-omap <linux-omap@vger.kernel.org>, linux-arm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 7:58 AM, Luciano Coelho <coelho@ti.com> wrote:
> On Thu, 2013-06-27 at 07:51 -0500, Nishanth Menon wrote:
>> On 11:47-20130627, Luciano Coelho wrote:
>> > (added mailing lists and everyone back to the thread)
>> >
>> > On Wed, 2013-06-26 at 23:38 -0500, Nishanth Menon wrote:
>> > > On 06/25/2013 03:35 AM, Luciano Coelho wrote:
>> > > > +Optional properties:
>> > > > +--------------------
>> > > > +
>> > > > +- refclock: the internal WLAN reference clock frequency (required for
>> > > > +  WiLink6 and WiLink7; not used for WiLink8).  Must be one of the
>> > > > +  following:
>> > > > +       0 = 19.2 MHz
>> > > > +       1 = 26.0 MHz
>> > > > +       2 = 38.4 MHz
>> > > > +       3 = 52.0 MHz
>> > > > +       4 = 38.4 MHz, XTAL
>> > > > +       5 = 26.0 MHz, XTAL
>> > > > +
>> > > > +- tcxoclock: the internal WLAN TCXO clock frequency (required for
>> > > > +  WiLink7 not used for WiLink6 and WiLink8).  Must be one of the
>> > > > +  following:
>> > > > +       0 = 19.200 MHz
>> > > > +       1 = 26.000 MHz
>> > > > +       2 = 38.400 MHz
>> > > > +       3 = 52.000 MHz
>> > > > +       4 = 16.368 MHz
>> > > > +       5 = 32.736 MHz
>> > > > +       6 = 16.800 MHz
>> > > > +       7 = 33.600 MHz
>> > > >
>> > > just a gentle query - why not use frequency itself here in Hz for
>> > > refclock and txoclk?
>> >
>> > I thought about using the actual frequencies, but I decided not to do
>> > so, because I'd have to convert them to these values anyway.  These
>> > values are used to configure the firmware and it uses these
>> > "enumerations".
>> Could we not hide this under preprocessor macros instead? just wondering
>> of txoclock = <6>; kind of usage.. easy to make mistakes and easier to
>> confuse a new reader :).
>
> Yes, I guess we could create some preprocessor macros for this.  But the
> documentation would remain the same.  I can't add preprocessor macros to
> the bindings documentation. ;)
>
> For the actual DTS files, I could add a wilink.dtsi with enumerations
> for these values so they could be used in the node definitions.  But I'm
> not sure it's going to be that valuable in the end.
The  way GPIO HIGH was defined might help to provide guidance I think :)

Regards,
NM
