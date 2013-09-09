Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002Ab3IIWXf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 18:23:35 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:49345 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755472Ab3IIWXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 18:23:34 -0400
Date: Mon, 9 Sep 2013 15:23:30 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Wei Ni <wni@nvidia.com>, khali@linux-fr.org, broonie@kernel.org,
        lm-sensors@lm-sensors.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] Documentation: dt: hwmon: add OF document for LM90
Message-ID: <20130909222330.GA31708@roeck-us.net>
References: <1378722552-10357-1-git-send-email-wni@nvidia.com>
 <1378722552-10357-3-git-send-email-wni@nvidia.com>
 <522E489D.6080903@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <522E489D.6080903@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 04:15:57PM -0600, Stephen Warren wrote:
> On 09/09/2013 04:29 AM, Wei Ni wrote:
> > Add OF document for LM90 in Documentation/devicetree/.
> 
> > diff --git a/Documentation/devicetree/bindings/hwmon/lm90.txt
> > b/Documentation/devicetree/bindings/hwmon/lm90.txt
> 
> > +Optional properties:
> 
> > +- interrupts: Contains a single interrupt specifier which
> > describes the +              LM90 pin6 output.
> 
> Does the pin also have a standard name you could include here, rather
> than (or in addition to) just the pin number?
> 
This is the "ALERT" pin (or maybe "-ALERT" to reflect that it is low-active).

Guenter
