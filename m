Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814AbaBGNCH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:02:07 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:39889 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753037AbaBGNB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 08:01:59 -0500
Message-ID: <1391778043.27491.61.camel@iivanov-dev>
Subject: Re: [PATCH RESEND 1/2] spi: qup: Add device tree bindings
 information
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Mark Brown <broonie@kernel.org>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        linux-spi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 07 Feb 2014 15:00:43 +0200
In-Reply-To: <20140207122716.GH32298@sirena.org.uk>
References: <20140206175059.GW32298@sirena.org.uk>
	 <1391759007-25305-1-git-send-email-iivanov@mm-sol.com>
	 <20140207122716.GH32298@sirena.org.uk>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2014-02-07 at 12:27 +0000, Mark Brown wrote: 
> On Fri, Feb 07, 2014 at 09:43:27AM +0200, Ivan T. Ivanov wrote:
> > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > 
> > The Qualcomm Universal Peripheral (QUP) core is an
> > AHB slave that provides a common data path (an output
> > FIFO and an input FIFO) for serial peripheral interface
> > (SPI) mini-core.
> 
> Please fix the formatting of this document so the lines are less than 80
> columns, it's hard to read as is.  Otherwise this is fine.

File is looking fine in editor with smart tab support

Regards,
Ivan


