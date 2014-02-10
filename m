Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142AbaBJU77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 15:59:59 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:51232 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260AbaBJU74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 15:59:56 -0500
Subject: Re: [PATCH 2/2] spi: Add Qualcomm QUP SPI controller support
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Courtney Cavin <courtney.cavin@sonymobile.com>
Cc: Andy Gross <agross@codeaurora.org>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Alok Chauhan <alokc@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Kiran Gunda <kgunda@codeaurora.org>,
        Sagar Dharia <sdharia@codeaurora.org>
In-Reply-To: <20140210202926.GV1706@sonymobile.com>
References: <1391705868-20091-1-git-send-email-iivanov@mm-sol.com>
	 <1391705868-20091-3-git-send-email-iivanov@mm-sol.com>
	 <20140207073952.GA2610@qualcomm.com>
	 <1391766753.27491.60.camel@iivanov-dev>
	 <20140207173207.GA19974@qualcomm.com>
	 <1392051302.2853.56.camel@iivanov-dev>
	 <20140210174738.GA31596@qualcomm.com> <1392061304.24621.17.camel@violet>
	 <20140210202926.GV1706@sonymobile.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Feb 2014 22:59:54 +0200
Message-ID: <1392065994.32668.1.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, 

On Mon, 2014-02-10 at 12:29 -0800, Courtney Cavin wrote:
> On Mon, Feb 10, 2014 at 08:41:44PM +0100, Ivan T. Ivanov wrote:
> > 
> > Hi,
> > 
> > On Mon, 2014-02-10 at 11:47 -0600, Andy Gross wrote:
> > > On Mon, Feb 10, 2014 at 06:55:02PM +0200, Ivan T. Ivanov wrote:
> > > 
> > > [....]
> > > 
> > > > > > > Bail here?
> > > > > > 
> > > > > > I don't know. What will be the consequences if controller continue to
> > > > > > operate on its default rate?
> > > > > > 
> > > > > 
> > > > > It is unclear.  But if you can't set the rate that is configured or if there is
> > > > > a misconfiguration, it's probably better to exit the probe and catch it here.
> > > > 
> > > > 
> > > > My preference is to delay clock speed change till first
> > > > SPI transfer. And use wherever transfer itself mandate.
> > > > 
> > > 
> > > That works.  My only concern is that it might be nice to catch a configuration
> > > problem early rather than wait for the SPI transfer to fail continuously.
> > 
> > If developer is skilled enough to know which version controller is,
> > (s)he will be able to put the right frequency constrain here :-)
> 
> A developer doesn't have to have much skill at all to copy-paste DT
> configurations around and muck with numbers....  I agree with Andy here,
> early validation is a good idea here, at the very least, some sanity
> checks.
> 

So, probably first variant with just warning will be good enough? 

Regards,
Ivan


> -Courtney


