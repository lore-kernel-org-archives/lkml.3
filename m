Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759472Ab3GRVVH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 17:21:07 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:64253 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759144Ab3GRVVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 17:21:05 -0400
Date: Thu, 18 Jul 2013 14:21:08 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Eduardo Valentin <eduardo.valentin@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, wni@nvidia.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org, l.stach@pengutronix.de
Subject: Re: [lm-sensors] [RESEND PATCH V1 0/9] thermal: introduce DT thermal
 zone build
Message-ID: <20130718212108.GC4110@roeck-us.net>
References: <1374074248-31690-1-git-send-email-eduardo.valentin@ti.com>
 <20130717220942.GB990@roeck-us.net>
 <51E7F341.8020508@ti.com>
 <51E8234D.1020607@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E8234D.1020607@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 11:18:05AM -0600, Stephen Warren wrote:
> On 07/18/2013 07:53 AM, Eduardo Valentin wrote:
> > Hello Guenter,
> > 
> > On 17-07-2013 18:09, Guenter Roeck wrote:
> >> On Wed, Jul 17, 2013 at 11:17:19AM -0400, Eduardo Valentin
> >> wrote:
> >>> Hello all,
> >>> 
> >>> As you noticed, I am working in a way to represent thermal
> >>> data using device tree [1]. Essentially, this should be a way
> >>> to say what to do with a sensor and how to associate (cooling)
> >>> actions with it.
> >>> 
> >> Seems to me that goes way beyond the supposed scope of devicetree
> >> data. Devicetree data is supposed to describe hardware, not its
> >> configuration or use. This is clearly a use case.
> > 
> > Thanks for rising your voice here. It is important to know what
> > hwmon ppl think about this.
> 
> I meant to find time to read Guenter's original email where he
> initially objected to putting data into DT, and determine exactly what
> was being objected to. I still haven't:-( However, the arguments that
> Eduardo stated in his email do make sense to me; I agree that
> temperature limits really are a description of HW. Details of which
> cooling methods to invoke when certain temperature limits are reached
> is also part of the HW/system design, and hence I would tend to agree
> that they're appropriate to include in DT. Anyway, that's just my 2
> cents on the matter:-)

Many systems have multiple profiles for various use cases (high performance,
low power etc), and limits are different based on the use case. If that means
you are going to have multiple devicetree variants based on the profile,
I would argue that you crossed the line. With thermal profiles it gets even more
complicated, as those parameters may be played around with and changed
multiple times to find the best settings to achieve optimal cooling.
Does this describe hardware ? I don't think so, but, as I mentioned before,
maybe I am wrong.

Guenter
