Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744AbaDCUQQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 16:16:16 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:46937
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753552AbaDCUQL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 16:16:11 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI9371Ic89bh936eI1432I4015Izz1f42h2148h1ee6h1de0h1fdah2149h2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chz8dhz1de098h8275bh1de097hz2fh95h839h93fhc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24d7h2516h2545h255eh25f6h2605h268bh26d3h906i2673i1155h)
Date: Thu, 3 Apr 2014 13:15:52 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Rob Herring <robherring2@gmail.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Mike Looijmans <mike.looijmans@topic.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Harini Katakam <harinik@xilinx.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH v4 1/3] i2c: cadence: Document device tree bindings
References: <1396547967-19260-1-git-send-email-soren.brinkmann@xilinx.com>
 <CAL_Jsq+vOHzca_wT9ADHRxhR9dT8FYGP-iTvd5=zKrRVBZz-cw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <CAL_Jsq+vOHzca_wT9ADHRxhR9dT8FYGP-iTvd5=zKrRVBZz-cw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <19eac9d5-7c83-4fca-b3e8-fc225b6559bd@CH1EHSMHS033.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-04-03 at 02:51PM -0500, Rob Herring wrote:
> On Thu, Apr 3, 2014 at 12:59 PM, Soren Brinkmann
> <soren.brinkmann@xilinx.com> wrote:
> > Add device tree binding documentation for the Cadence I2C controller.
> >
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > ---
> >
> > Changes in v4:
> >  - moved adding DT docs into this dedicated patch
> >
> > Changes in v3: None
> > Changes in v2: None
> >
> > ---
> >  .../devicetree/bindings/i2c/i2c-cadence.txt         | 21 +++++++++++++++++++++
> >  1 file changed, 21 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/i2c/i2c-cadence.txt
> >
> > diff --git a/Documentation/devicetree/bindings/i2c/i2c-cadence.txt b/Documentation/devicetree/bindings/i2c/i2c-cadence.txt
> > new file mode 100644
> > index 000000000000..685adf513111
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/i2c/i2c-cadence.txt
> > @@ -0,0 +1,21 @@
> > +Binding for the Cadence I2C controller
> > +
> > +Required properties:
> > +  compatible: Compatibility string. Must be 'cdns,i2c-r1p10'.
> > +  clocks: From common clock bindings. Phandle to input clock.
> > +
> > +Optional properties:
> > +  clock-frequency: Desired operating frequency, in Hz, of the bus (actual may
> > +                  be lower). Defaults to 400000 if not specified.
> 
> Since not all devices support 400kHz, I would prefer that the default
> be 100kHz. Also, it would be good if what speed the default is
> consistent across i2c drivers.

Fine with me. I'll change this.

	Thanks,
	Sören


