Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbaIXPxP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:53:15 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:14621 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750940AbaIXPxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:53:13 -0400
Date: Wed, 24 Sep 2014 08:53:20 -0700
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Lee Jones <lee.jones@linaro.org>, Rob Herring <robh+dt@kernel.org>
CC: Mark Brown <broonie@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Andy Gross <agross@codeaurora.org>,
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
Message-ID: <20140924155319.GA28481@sonymobile.com>
References: <1411428329-23172-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1411428329-23172-2-git-send-email-bjorn.andersson@sonymobile.com>
 <20140924082228.GF17801@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140924082228.GF17801@lee--X1>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 24 Sep 01:22 PDT 2014, Lee Jones wrote:

> On Mon, 22 Sep 2014, Bjorn Andersson wrote:
> 
> > Add binding for the Qualcomm Resource Power Manager (RPM) found in 8660,
> > 8960 and 8064 based devices. The binding currently describes the rpm
> > itself and the regulator subnodes.
> > 
> > Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> > ---
> >  Documentation/devicetree/bindings/mfd/qcom-rpm.txt |  246 ++++++++++++++++++++
> 
> Please adhere to: Documentation/devicetree/bindings/submitting-patches.txt
> 

I assume you mean this part:

  1) The Documentation/ portion of the patch should be a separate patch.

But I doubt this document was written with include/dt-bindings in mind, because
in my eyes they are part of "device tree bindings".

> >  include/dt-bindings/mfd/qcom-rpm.h                 |  154 ++++++++++++
> >  2 files changed, 400 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/mfd/qcom-rpm.txt
> >  create mode 100644 include/dt-bindings/mfd/qcom-rpm.h
> > 
> > diff --git a/Documentation/devicetree/bindings/mfd/qcom-rpm.txt b/Documentation/devicetree/bindings/mfd/qcom-rpm.txt
> > new file mode 100644
> > index 0000000..4264021
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/mfd/qcom-rpm.txt
> 
> This requires a DT Ack.
> 
> [...]
> 
> > +++ b/include/dt-bindings/mfd/qcom-rpm.h
> 
> Please split this into a separate patch.
> 

But this is part of the device tree binding and the binding "depends" on it.

> When you do, for this file only, please apply my:
> 
>   Acked-by: Lee Jones <lee.jones@linaro.org>
> 

Thanks,
Bjorn
