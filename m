Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbaIQQQB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 12:16:01 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:44737 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755449AbaIQQP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 12:15:58 -0400
Date: Wed, 17 Sep 2014 09:15:54 -0700
From: Lee Jones <lee.jones@linaro.org>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Rob Herring <robh+dt@kernel.org>, Mark Brown <broonie@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Andy Gross <agross@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>, Kevin Hilman <khilman@linaro.org>,
        Kumar Gala <galak@codeaurora.org>,
        Josh Cartwright <joshc@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v6 1/3] mfd: devicetree: bindings: Add Qualcomm RPM DT
 binding
Message-ID: <20140917161554.GJ30918@lee--X1>
References: <1409029109-28769-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1409029109-28769-2-git-send-email-bjorn.andersson@sonymobile.com>
 <20140826072727.GB9574@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140826072727.GB9574@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2014, Lee Jones wrote:

> On Mon, 25 Aug 2014, Bjorn Andersson wrote:
> 
> > Add binding for the Qualcomm Resource Power Manager (RPM) found in 8660,
> > 8960 and 8064 based devices. The binding currently describes the rpm
> > itself and the regulator subnodes.
> > 
> > Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> > ---
> >  Documentation/devicetree/bindings/mfd/qcom,rpm.txt |  246 ++++++++++++++++++++
> >  include/dt-bindings/mfd/qcom,rpm.h                 |  154 ++++++++++++
> >  2 files changed, 400 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/mfd/qcom,rpm.txt
> >  create mode 100644 include/dt-bindings/mfd/qcom,rpm.h
> 
> Please use the same filename formatting as the existing files.

Are you going to resubmit this (and answer my question on the
regulator patch)?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
