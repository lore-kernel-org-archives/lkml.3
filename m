Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933150Ab3HNTLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 15:11:44 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:38206 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933065Ab3HNTLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 15:11:41 -0400
Subject: Re: [PATCH v3 3/3] usb: dwc3: Add Qualcomm DWC3 glue layer driver
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: balbi@ti.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org, ian.campbell@citrix.com,
        rob@landley.net, gregkh@linuxfoundation.org, grant.likely@linaro.org,
        idos@codeaurora.org, mgautam@codeaurora.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-msm@vger.kernel.org
In-Reply-To: <520BAB07.8050203@codeaurora.org>
References: <1376485183-2664-1-git-send-email-iivanov@mm-sol.com>
	 <1376485183-2664-4-git-send-email-iivanov@mm-sol.com>
	 <520BAB07.8050203@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Aug 2013 22:11:39 +0300
Message-ID: <1376507499.22506.0.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-14 at 09:06 -0700, Stephen Boyd wrote:
> On 08/14/13 05:59, Ivan T. Ivanov wrote:
> > +}
> > +
> > +static const struct of_device_id of_dwc3_matach[] = {
> 
> match? Maybe you can make it all one line too { .compatible = "qcom,dwc3" }
> 

Thanks. Will do.

Ivan

> > +	{
> > +		.compatible = "qcom,dwc3",
> > +	},
> > +	{ },
> > +};
> > +MODULE_DEVICE_TABLE(of, of_dwc3_matach);
> > +
> >


