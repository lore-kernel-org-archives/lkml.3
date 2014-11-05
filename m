Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbaKENuP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 08:50:15 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:56098 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191AbaKENuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 08:50:12 -0500
Message-ID: <1415195429.3660.2.camel@mm-sol.com>
Subject: Re: [PATCH] mfd: qcom-spmi-pmic: Add support for more chips versions
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Andreas =?ISO-8859-1?Q?F=E4rber?= <afaerber@suse.de>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Date: Wed, 05 Nov 2014 15:50:29 +0200
In-Reply-To: <545A1CD2.4030407@suse.de>
References: <1415108003-16387-1-git-send-email-iivanov@mm-sol.com>
	 <545A1CD2.4030407@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.13.6-fta3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2014-11-05 at 13:49 +0100, Andreas Färber wrote:
> Hi,
> 
> Am 04.11.2014 um 14:33 schrieb Ivan T. Ivanov:
> > Update compatible string with runtime detected chip revision
> > information, for example qcom,pm8941 will become qcom,pm8941-v1.0.
> 
> That's not what the patch does though?

Patch add support for more chips and make compatible property more specific.
Will correct description.

> 
> > Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> > ---
> >  .../devicetree/bindings/mfd/qcom,spmi-pmic.txt     |  18 ++-
> >  drivers/mfd/qcom-spmi-pmic.c                       | 142 +++++++++++++++++++++
> >  2 files changed, 156 insertions(+), 4 deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/mfd/qcom,spmi-pmic.txt 
> > b/Documentation/devicetree/bindings/mfd/qcom,spmi-pmic.txt
> > index 7182b88..bbe7db8 100644
> > --- a/Documentation/devicetree/bindings/mfd/qcom,spmi-pmic.txt
> > +++ b/Documentation/devicetree/bindings/mfd/qcom,spmi-pmic.txt
> > @@ -15,10 +15,20 @@ each. A function can consume one or more of these fixed-size register 
> > regions.
> > 
> >  Required properties:
> >  - compatible:      Should contain one of:
> > -                     "qcom,pm8941"
> > -                     "qcom,pm8841"
> > -                     "qcom,pma8084"
> > -                     or generalized "qcom,spmi-pmic".
> > +                   qcom,pm8941,
> > +                   qcom,pm8841,
> > +                   qcom,pm8019,
> > +                   qcom,pm8226,
> > +                   qcom,pm8110,
> > +                   qcom,pma8084,
> > +                   qcom,pmi8962,
> > +                   qcom,pmd9635,
> > +                   qcom,pm8994,
> > +                   qcom,pmi8994,
> > +                   qcom,pm8916,
> > +                   qcom,pm8004,
> > +                   qcom,pm8909,
> 
> Please either keep the strings consistently quoted, or drop the trailing
> comma to avoid any confusion of where it terminates.

Sure, will fix it.

Thank you,
Ivan


