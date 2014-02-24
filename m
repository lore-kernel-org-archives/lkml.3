Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639AbaBXKec (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 05:34:32 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:52531 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbaBXKea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 05:34:30 -0500
Message-ID: <1393237990.6481.15.camel@iivanov-dev>
Subject: Re: [PATCH v3 2/2] i2c: New bus driver for the Qualcomm QUP I2C
 controller
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Kumar Gala <galak@codeaurora.org>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree <devicetree@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Wolfram Sang <wsa@the-dreams.de>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, linux-i2c@vger.kernel.org,
        Rob Landley <rob@landley.net>, Andy Gross <agross@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Date: Mon, 24 Feb 2014 12:33:10 +0200
In-Reply-To: <92B0AE30-5CDF-43FC-8588-EEF0C5F86266@codeaurora.org>
References: <1392943090-30556-1-git-send-email-bjorn.andersson@sonymobile.com>
	 <1392943090-30556-3-git-send-email-bjorn.andersson@sonymobile.com>
	 <92B0AE30-5CDF-43FC-8588-EEF0C5F86266@codeaurora.org>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

On Fri, 2014-02-21 at 09:35 -0600, Kumar Gala wrote: 
> On Feb 20, 2014, at 6:38 PM, Bjorn Andersson <bjorn.andersson@sonymobile.com> wrote:
> 
> > This bus driver supports the QUP i2c hardware controller in the Qualcomm SOCs.
> > The Qualcomm Universal Peripheral Engine (QUP) is a general purpose data path
> > engine with input/output FIFOs and an embedded i2c mini-core. The driver
> > supports FIFO mode (for low bandwidth applications) and block mode (interrupt
> > generated for each block-size data transfer).
> > 
> > Cc: Andy Gross <agross@codeaurora.org>
> > Cc: Stephen Boyd <sboyd@codeaurora.org>
> > Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> > Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> > ---

<snip>

> > 
> > +config I2C_QUP
> > +	tristate "Qualcomm QUP based I2C controller"
> > +	depends on ARCH_MSM
> 
> ARCH_QCOM

There is no such symbol, still.

Regards,
Ivan 


> - k
> 


