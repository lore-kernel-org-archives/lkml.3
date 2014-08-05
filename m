Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbaHELzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 07:55:38 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:56714 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753218AbaHELzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 07:55:36 -0400
Message-ID: <1407239718.2475.76.camel@iivanov-dev>
Subject: Re: [PATCH v2 2/4] pinctrl: qpnp: Qualcomm PMIC pin controller
 driver
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: David Collins <collinsd@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org
Date: Tue, 05 Aug 2014 14:55:18 +0300
In-Reply-To: <53E0350C.4020003@codeaurora.org>
References: <1405610748-7583-1-git-send-email-iivanov@mm-sol.com>
	  <1405610748-7583-3-git-send-email-iivanov@mm-sol.com>
	  <53D307BB.1020208@codeaurora.org> <1406536774.2475.36.camel@iivanov-dev>
	 <53E0350C.4020003@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.1-2ubuntu2~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-08-04 at 18:36 -0700, Stephen Boyd wrote:
> On 07/28/14 01:39, Ivan T. Ivanov wrote:
> > I am working on proposal from Stephen Boyd to encode GPIO/MPP mode and 
> > source select into combined function. Something like this one:
> >
> > #define PM8XXX_DIGITAL_IN		0
> > #define PM8XXX_DIGITAL_OUT		1
> > #define PM8XXX_DIGITAL_IN_OUT		2
> >
> > ...
> >
> > /* mode and source select */
> > #define PM8XXX_FUNCTION(m,s)		((m) << 16 | (s))
> >
> > #define PM8921_GPIO1_14_KYPD_SNS	PM8XXX_FUNCTION(PM8XXX_DIGITAL_IN, 1)
> > #define PM8921_GPIO9_14_KYPD_DRV	PM8XXX_FUNCTION(PM8XXX_DIGITAL_OUT, 1)
> > #define PM8921_GPIO33_35_PWM		PM8XXX_FUNCTION(PM8XXX_DIGITAL_OUT, 3)
> >
> > ..
> >
> >
> 
> This isn't what I was suggesting at all. The function should be
> something like KYPD, PWM and those should just be defined to be 1 or 3.
> The mode should be some other property like input or output, and the
> driver should or the two together and put it into the register.

Well, we can do this. I was just thought that will more convenient if
function is fully described in to one property.

Regards,
Ivan


