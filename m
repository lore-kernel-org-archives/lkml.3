Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbaH1Oqh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 10:46:37 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:55423 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbaH1Oqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 10:46:34 -0400
Date: Thu, 28 Aug 2014 10:46:34 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Courtney Cavin <courtney.cavin@sonymobile.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        "eduardo.valentin@ti.com" <eduardo.valentin@ti.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] thermal: add generic IIO channel thermal sensor driver
Message-ID: <20140828144632.GA18194@developer>
References: <1391651007-29813-1-git-send-email-courtney.cavin@sonymobile.com>
 <1393484014.2637.14.camel@rzhang1-mobl4>
 <20140314211952.GJ18578@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140314211952.GJ18578@sonymobile.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 02:19:53PM -0700, Courtney Cavin wrote:
> On Thu, Feb 27, 2014 at 07:53:34AM +0100, Zhang Rui wrote:
> > On Wed, 2014-02-05 at 17:43 -0800, Courtney Cavin wrote:
> > > This driver is a generic method for using IIO ADC channels as thermal
> > > sensors.
> > > 
> > > Signed-off-by: Courtney Cavin <courtney.cavin@sonymobile.com>
> > 
> > Eduardo,
> > 
> > what do you think of this patch?
> 
> Apparently not very much.  Oh well.

Curtney,

Apolizes, this one fell into the cracks.


> 
> Sans further input, I will submit a new series with the following
> changes:
> 	- Fix some return values in probe().
> 	- Change DT binding
> 		- Submit as seperate patch in series
> 		- Reword/rename to represent a thermistor
> 		- Remove specific references to IIO, where appropriate


Do you already send your new version or the current one is still the
latest?

> 
> -Courtney
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
