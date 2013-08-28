Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab3H1G3N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 02:29:13 -0400
Received: from mail1.bemta14.messagelabs.com ([193.109.254.116]:61127 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752728Ab3H1G3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 02:29:09 -0400
X-Greylist: delayed 382 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Aug 2013 02:29:08 EDT
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-10.tower-194.messagelabs.com!1377670963!15397188!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.9.11; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Wed, 28 Aug 2013 08:22:44 +0200
Date: Wed, 28 Aug 2013 08:22:32 +0200
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Johannes Thumshirn <johannes.thumshirn@men.de>,
        Rob Landley <rob@landley.net>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Wim Van Sebroeck <wim@iguana.be>, Guenter Roeck <linux@roeck-us.net>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-watchdog@vger.kernel.org>
Subject: Re: [RFC][PATCH v2] documentation/devicetree: Move DT bindigns from
 gpio to watchdog
Message-ID: <20130828062232.GA10368@jtlinux>
References: <521672A1.6010202@wwwdotorg.org>
 <1377601837-18989-1-git-send-email-johannes.thumshirn@men.de>
 <521D1D16.9080106@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <521D1D16.9080106@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [192.1.1.31]
X-OriginalArrivalTime: 28 Aug 2013 06:22:43.0605 (UTC) FILETIME=[01464C50:01CEA3B7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 03:41:42PM -0600, Stephen Warren wrote:
> On 08/27/2013 05:10 AM, Johannes Thumshirn wrote:
> > I accidently put the devicetree bindings for the MEN A21 watchdog driver in
> > Documentation/devicetree/bindings/gpio instead of
> > Documentation/devicetree/bindings/watchdog, this patch addresses this error.
>
> >  Changes to v1:
> >  - Use named gpios, as suggested by Stephen Warren
>
> The move and the change to the binding should probably be separate
> patches since they're logically separate things. I didn't intend you to
> update the rename patch to fix the binding issue I pointed out.
>

Oops. Looks like I've misunderstood you there. I'll re-send the rename patch
then.

> Is the driver updated for this binding change? Are there DTs in released
> kernels that won't work now, or is the driver very new; there may be a
> need for the driver to support the old binding and the binding doc to
> document the old gpios property, but mark it deprecated.

The driver is not yet updated, this is why I've sent it as an RFC. Are the
bindings acceptable this way? If yes I'll update the driver and re-send the
bindings with the driver as a new patch series.

Johannes
