Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786Ab3GYQiW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 12:38:22 -0400
Received: from service87.mimecast.com ([91.220.42.44]:46331 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756470Ab3GYQiS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 12:38:18 -0400
Message-ID: <1374770294.3213.35.camel@hornet>
Subject: Re: RFC: device thermal limits represented in device tree nodes
From: Pawel Moll <pawel.moll@arm.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Durgadoss R <durgadoss.r@intel.com>,
        "Zhang, Rui" <rui.zhang@intel.com>, Wei Ni <wni@nvidia.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 25 Jul 2013 17:38:14 +0100
In-Reply-To: <1374768928.3213.31.camel@hornet>
References: <51ED40E3.5020703@ti.com> <51EF3186.9060001@wwwdotorg.org>
	 <1374664745.25700.118.camel@hornet> <51EFED19.5090900@ti.com>
	 <1374768928.3213.31.camel@hornet>
X-Mailer: Evolution 3.8.2-0ubuntu1~raring1
Mime-Version: 1.0
X-OriginalArrivalTime: 25 Jul 2013 16:38:14.0426 (UTC) FILETIME=[5BB6DFA0:01CE8955]
X-MC-Unique: 113072517381605701
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-25 at 17:15 +0100, Pawel Moll wrote:
> > Another way, as I mentioned in the original RFC, an option would be to
> > have the thermal_zone node not embedded in any device node. But them, we
> > would need to firmly link it to other device nodes, to describe what is
> > monitored and what is used for monitoring. 
> 
> You mean the zone nodes would live at the top level of the tree? To my
> mind the root represents the device (the board, whatever you call it),

What I wanted to say was: ... so the zone would still be embedded in a
device node :-)

Pawel


