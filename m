Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbaJULlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 07:41:18 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:51777 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755196AbaJULlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 07:41:15 -0400
Message-ID: <1413891687.30282.4.camel@mm-sol.com>
Subject: Re: [PATCH v5 0/4] Qualcomm SPMI PMIC pin controller drivers
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Date: Tue, 21 Oct 2014 14:41:27 +0300
In-Reply-To: <CACRpkdaZ8o=Kmbez3iA_-0euuWQKwKyNNYPjnx1fBZOns0yN6A@mail.gmail.com>
References: <1412181058-29179-1-git-send-email-iivanov@mm-sol.com>
	 <CACRpkdaZ8o=Kmbez3iA_-0euuWQKwKyNNYPjnx1fBZOns0yN6A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.13.5-fta1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2014-10-21 at 12:59 +0200, Linus Walleij wrote:
> On Wed, Oct 1, 2014 at 6:30 PM, Ivan T. Ivanov <iivanov@mm-sol.com> 
> wrote:
> 
> >  Changes since v4:
> > >
> >  - Use PMIC name in compatible string.
> >  - PINCTRL_QCOM_SPMI_PMIC from Kconfig symbol.
> >  - Remove pmic string from drivers file names.
> >  - Fixed coding style issues.
> >  - Use qcom-spmi-gpio and qcom-spmi-mpp from dirver names,
> >    to be similar to qcom-spmi-iadc, qcom-spmi-vadc and
> >    qcom-spmi-temp-alarm drivers.
> > >
> >  Short description:
> > >
> >  Patches adds pin control drivers for Multi-Purpose Pin (MPP) and
> >  General-purpose pin (GPIO) controllers found in Qualcomm SPMI 
> > based
> >  PMIC chips.
> > >
> >  MPP's are enhanced GPIO's with analog circuits, which support
> >  analog and digital input/output.
> 
> I think I'm happy to apply this for v3.19 now that I have Björn's
> ACK on it too (or is it even Reviewed-by..?)
> 
> But I can't find these patches in my mailbox, do you have
> a branch based off v3.18-rc1 I can pull from?

They are prepared but not sent. Will try to send them shortly. 

Thank you.
Ivan

> 
> Yours,
> Linus Walleij
> 

