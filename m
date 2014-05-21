Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268AbaEUKC6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 06:02:58 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:60922 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbaEUKCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 06:02:53 -0400
Date: Wed, 21 May 2014 11:02:45 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Olof Johansson <olof@lixom.net>
Cc: Maxime COQUELIN <maxime.coquelin@st.com>, Rob Landley <rob@landley.net>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@stlinux.com" <kernel@stlinux.com>
Subject: Re: [PATCH v4 6/6] ARM: dts: STiH407: Add B2120 board support
Message-ID: <20140521100245.GI6679@lee--X1>
References: <1394614210-15698-1-git-send-email-maxime.coquelin@st.com>
 <1394614210-15698-7-git-send-email-maxime.coquelin@st.com>
 <CAOesGMg5Jk_XB3zdfKz8VxRObYbFO8OMuRyo7Ba-kavANbci1w@mail.gmail.com>
 <20140520072048.GC20874@lee--X1>
 <CAOesGMioLwX3jgGEsR=rHV0u6yR54b4x8BfyZ91vjJnMapUHew@mail.gmail.com>
 <20140520074353.GD20874@lee--X1>
 <CAOesGMigF7CGtTmLMW4zbRemGaMbWs6NV6KLPFZQFYmnHc=HQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOesGMigF7CGtTmLMW4zbRemGaMbWs6NV6KLPFZQFYmnHc=HQw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> >> > +       soc {
> >> >> > +               sbc_serial0: serial@9530000 {
> >> >> > +                       status = "okay";
> >> >> > +               };
> >> >>
> >> >> You might want to consider reference-based syntax here instead, so you
> >> >> don't have to mimic the hierarchy. That'd be (at the root level of the
> >> >> file, below this secion:
> >> >>
> >> >> &sbc_serial0: {
> >> >>         status = "okay";
> >> >> };
> >> >
> >> > I'm personally not keen on this scheme.  It's sometimes helpful to know
> >> > the hierarchy and I don't think it's a large overhead to format the
> >> > subordinate DTS files in this way.
> >> >
> >> > Please consider not enforcing this.
> >>
> >> Definitely not enforcing it, and I didn't use to like it either but it
> >> has some real upsides.
> >>
> >> In particular, it saves a lot of grief when you're changing something
> >> like the unit-id of a node in .dtsi and forget to do the same update
> >> in the dts.
> >
> > I'm not entirely sure what a unit-id is, but I can see that there
> > would be benefits to using the referenced-based syntax as you call
> > it.  If any of those benefits hold true here I won't push back, but I
> > would personally like to see us default to the hierarchical scheme.
> 
> Sorry, I meant unit-address. I.e. the portion that goes behind the @
> in the node name.

Ah yes, makes sense now, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
