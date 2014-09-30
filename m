Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640AbaI3Pdp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 11:33:45 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:6789 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750782AbaI3Pdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 11:33:44 -0400
Date: Tue, 30 Sep 2014 08:33:54 -0700
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Kumar Gala <galak@codeaurora.org>, Mark Brown <broonie@kernel.org>
CC: Rob Herring <robh+dt@kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Pawel Moll <pawel.moll@arm.com>, Andy Gross <agross@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>, Kevin Hilman <khilman@linaro.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v7 3/3] regulator: qcom-rpm: Regulator driver for the
 Qualcomm RPM
Message-ID: <20140930153353.GO28481@sonymobile.com>
References: <1411428329-23172-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1411428329-23172-4-git-send-email-bjorn.andersson@sonymobile.com>
 <20140924083518.GB4015@sirena.org.uk>
 <4437DA50-D8BC-4E78-821C-41440A08B9A9@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4437DA50-D8BC-4E78-821C-41440A08B9A9@codeaurora.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 24 Sep 06:50 PDT 2014, Kumar Gala wrote:

> 
> On Sep 24, 2014, at 3:35 AM, Mark Brown <broonie@kernel.org> wrote:
> 
> > On Mon, Sep 22, 2014 at 04:25:29PM -0700, Bjorn Andersson wrote:
> >> Driver for regulators exposed by the Resource Power Manager (RPM) found
> >> in Qualcomm 8660, 8960 and 8064 based devices.
> > 
> > Applied, thanks.

Thanks Mark, sorry for sending this to you so many times.  I'll keep the smd
rpm regulator separate from the smd series (after the RFC) to reduce the
traffic.

> 
> Mark, can you drop this until we see at least an RFC patch for the RPM
> support for b-family SoCs (8074, 8084, etc) chips.  The regulator could
> should either be the same or highly similar for b-family, but until we see
> the core RPM driver on the b-family SoCs we will not know that.
> 

As you can see in the smd rpm regulator driver, the protocol for regulator
updates are completely different in the two cases.  I'm not sure about msm_bus,
but the clocks implementation is equivalent, so there's some room for re-use.

So I think we're good here.

Regards,
Bjorn
