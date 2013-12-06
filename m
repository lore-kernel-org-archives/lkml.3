Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935Ab3LFC1m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 21:27:42 -0500
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:50885
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752282Ab3LFC1h convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 21:27:37 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(z579ehzbb2dI98dI9371I1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h177df4h8275eh17326ah8275bh1de097h186068ha1495iz2dh109h2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h2184h21a6h2216h22d0h2336hbe9i1155h)
From: Peter Chen <Peter.Chen@freescale.com>
To: Daniel Tang <dt.tangr@gmail.com>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: RE: [PATCH 1/2] usb: chipidea: fix mistake in device tree binding
 of nspire-usb to use vendor name 'lsi' instead of SoC name 'zevio'
Thread-Topic: [PATCH 1/2] usb: chipidea: fix mistake in device tree binding
 of nspire-usb to use vendor name 'lsi' instead of SoC name 'zevio'
Thread-Index: AQHO8NI470bGOAiBj0mFboeOh8gYwJpEkmWAgACGBICAALnIgP//kKaAgAEPxLA=
Date: Fri, 6 Dec 2013 02:27:17 +0000
Message-ID: <F281D0F91ED19E4D8E63A7504E8A649804145971@039-SN2MPN1-021.039d.mgd.msft.net>
References: <1386148808-15065-1-git-send-email-dt.tangr@gmail.com>
 <20131204134433.GD1573@shlinux1.ap.freescale.net>
 <38AC4BA3-DE10-47A6-B3EF-26872A88AABD@gmail.com>
 <20131205084909.GA25943@shlinux1.ap.freescale.net>
 <FAB4D64E-5DAD-4252-8B24-F076071D0279@gmail.com>
In-Reply-To: <FAB4D64E-5DAD-4252-8B24-F076071D0279@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.242.15]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> 
> Hi,
> 
> On 05/12/2013, at 7:49 PM, Peter Chen <Peter.Chen@freescale.com> wrote:
> 
> > On Thu, Dec 05, 2013 at 04:44:13PM +1100, Daniel Tang wrote:
> >> Hi,
> >>
> >> On 05/12/2013, at 12:44 AM, Peter Chen <Peter.Chen@freescale.com>
> wrote:
> >>
> >>>
> >>> lsi is vendor name, what are zevio and nspire?
> >>> Usually, the compatible string should be "vendor_name,soc_name-
> module_name"
> >>>
> >>
> >> Because this port uses documentation from reverse engineering, it's
> difficult to work out what is SoC specific and what is device specific.
> The SoC is Zevio but the driver is written for the TI-Nspire.
> >>
> >
> > Please wrap the line to 80 characters.
> >
> > The driver is written for the TI-Nspire, and you port this driver for
> > SoC Zevio platform?
> 
> The TI-Nspire runs on the Zevio SoC.
> 
> > Since you use chipidea ip, we don't care the usb
> > module name at your platform, we only care the soc name which you are
> > running, it can detect the SoC platform at runtime.
> >
> 
> Yep, that's why the latest patch I sent in renames the device tree
> binding to "lsi,zevio-usb" since zevio is the name of the SoC that the
> TI-Nspire uses.
> 
> > At your dts patch, it still uses nspire-usb.
> > http://marc.info/?l=linux-usb&m=138614886720024&w=2
> 
> I'll send a new one in right now.

OK, in order to avoid changing name again, I will queue your patch at my pending
chipidea tree until your dts has applied by arch or dts maintainer, notify me
when they are ready.

Peter



