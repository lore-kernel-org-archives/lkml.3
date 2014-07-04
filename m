Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758902AbaGDQb3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 12:31:29 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40883 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753285AbaGDQb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 12:31:26 -0400
Date: Fri, 4 Jul 2014 17:31:19 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Daniel Jeong <gshark.jeong@gmail.com>
Cc: Jingoo Han <jg1.han@samsung.com>, Bryan Wu <cooloney@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
        Daniel Jeong <daniel.jeong@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [RFC v4 2/2] backlight: device tree: add new tps611xx backlight
 binding
Message-ID: <20140704163119.GB7106@leverpostej>
References: <1404367277-12003-1-git-send-email-gshark.jeong@gmail.com>
 <1404367277-12003-3-git-send-email-gshark.jeong@gmail.com>
 <20140703090447.GC29837@leverpostej>
 <CAPqQCJUYqgireOiqK9DLpSAkw_4DdmKD+G7bXxVxf=bb0nTj6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPqQCJUYqgireOiqK9DLpSAkw_4DdmKD+G7bXxVxf=bb0nTj6Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>     > +- rfa-enable: enable request for acknowledge.
>     > +  If RFA is enabled, the data byte includes the RFA bit and device will
>     wait
>     > +  and check acknowledge from device.
> 
>     You didn't answer my question as to why this should be in the DT.
> 
> 
> According to the RFA enable, the easy scale pin works differently.
> This value should be set before the first data transfer.

Sure, things works differently if this is set. That I understood.

What I haven't heard is a rationale as to why this configuration option
shuold be in the DT.

Can I enable this on all implementations, or not?

When would I enable this and when would I not?

The property reads like a switch to turn a feature on, rather than the
description of the presence of a feature.

Mark.
