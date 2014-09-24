Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbaIXQV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:21:29 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:36011 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664AbaIXQVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:21:19 -0400
Date: Wed, 24 Sep 2014 17:21:12 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Rob Herring <robh+dt@kernel.org>, Mark Brown <broonie@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Andy Gross <agross@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>, Kevin Hilman <khilman@linaro.org>,
        Kumar Gala <galak@codeaurora.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v7 1/3] mfd: devicetree: bindings: Add Qualcomm RPM DT
 binding
Message-ID: <20140924162112.GB7113@lee--X1>
References: <1411428329-23172-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1411428329-23172-2-git-send-email-bjorn.andersson@sonymobile.com>
 <20140924082228.GF17801@lee--X1>
 <20140924155319.GA28481@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140924155319.GA28481@sonymobile.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2014, Bjorn Andersson wrote:

> On Wed 24 Sep 01:22 PDT 2014, Lee Jones wrote:
> 
> > On Mon, 22 Sep 2014, Bjorn Andersson wrote:
> > 
> > > Add binding for the Qualcomm Resource Power Manager (RPM) found in 8660,
> > > 8960 and 8064 based devices. The binding currently describes the rpm
> > > itself and the regulator subnodes.
> > > 
> > > Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> > > ---
> > >  Documentation/devicetree/bindings/mfd/qcom-rpm.txt |  246 ++++++++++++++++++++
> > 
> > Please adhere to: Documentation/devicetree/bindings/submitting-patches.txt
> > 
> 
> I assume you mean this part:
> 
>   1) The Documentation/ portion of the patch should be a separate patch.
> 
> But I doubt this document was written with include/dt-bindings in mind, because
> in my eyes they are part of "device tree bindings".

Actually, this is an oversight on my part.  If I would have seen that
this patch only touched the bindings and include/dt-bindings I
probably wouldn't have said anything.

This patch still needs a DT Ack though.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
