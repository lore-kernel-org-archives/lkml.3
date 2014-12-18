Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515AbaLRXhB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 18:37:01 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:19282 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751116AbaLRXg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 18:36:59 -0500
From: Bjorn <bjorn@sonymobile.com>
Date: Thu, 18 Dec 2014 15:36:53 -0800
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Bryan Wu <cooloney@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Grant Likely <grant.likely@linaro.org>,
        "Cavin, Courtney" <Courtney.Cavin@sonymobile.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH 1/2] leds: add DT binding for Qualcomm PM8941 WLED block
Message-ID: <20141218233652.GD19036@sonymobile.com>
References: <1418084551-28946-1-git-send-email-bjorn.andersson@sonymobile.com>
 <5490D949.4@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5490D949.4@codeaurora.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 16 Dec 17:15 PST 2014, Stephen Boyd wrote:

> On 12/08/2014 04:22 PM, Bjorn Andersson wrote:
> 
[..]
> > +- qcom,current-limit: mA; per-string current limit; value from 0 to 25
> > +	default: 20mA
> > +- qcom,current-boost-limit: mA; boost current limit; one of:
> > +	105, 385, 525, 805, 980, 1260, 1400, 1680
> > +	default: 805mA
[..]
> > +- qcom,ovp: V; Over-voltage protection limit; one of:
> > +	27, 29, 32, 35
> > +	default: 29V
> 
> It would be nice if the units were part of the property name, i.e.
> qcom,ovp-V, qcom,current-boost-limit-mA, etc. That way the units are
> known without having to refer to the documentation.
> 

That might be useful, on the other hand one probably need to look inte bindings
docs to figure out valid values anyways.

> > +- qcom,num-strings: #; number of led strings attached; value from 1 to 3
> > +	default: 2
> 
> I wonder if qcom,#strings is more appropriate?
> 

Checking the other docs indicate that it's far more common to use num- than #
here, but I haven't found anything written about it - it's more common to name
this just "qcom,strings" than "qcom,#strings" at least...

Regards,
Bjorn
