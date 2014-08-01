Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbaHALYH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 07:24:07 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:63369 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814AbaHALYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 07:24:05 -0400
Date: Fri, 1 Aug 2014 12:23:56 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        David Collins <collinsd@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v3 1/4] mfd: pm8xxx-spmi: add support for Qualcomm SPMI
 PMICs
Message-ID: <20140801112356.GP9030@lee--X1>
References: <1406205921-7452-1-git-send-email-svarbanov@mm-sol.com>
 <1406205921-7452-2-git-send-email-svarbanov@mm-sol.com>
 <53D8182A.5050204@codeaurora.org>
 <53DA02C0.2050606@mm-sol.com>
 <53DB5061.8080403@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53DB5061.8080403@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Aug 2014, Stanimir Varbanov wrote:
> On 07/31/2014 11:48 AM, Stanimir Varbanov wrote:
> > On 07/30/2014 12:54 AM, David Collins wrote:
> >> On 07/24/2014 05:45 AM, Stanimir Varbanov wrote:
> >>> From: Josh Cartwright <joshc@codeaurora.org>
> >>>
> >>> The Qualcomm SPMI PMIC chips are components used with the
> >>> Snapdragon 800 series SoC family.  This driver exists
> >>> largely as a glue mfd component, it exists to be an owner
> >>> of an SPMI regmap for children devices described in
> >>> device tree.
> >>>
> >>> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> >>> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
> >>> Acked-by: Lee Jones <lee.jones@linaro.org>
> >>> ---
> >>>  drivers/mfd/Kconfig       |   16 +++++++++++
> >>>  drivers/mfd/Makefile      |    1 +
> >>>  drivers/mfd/pm8xxx-spmi.c |   65 +++++++++++++++++++++++++++++++++++++++++++++
> >>
> >> Would it be possible to rename this driver: qcom-spmi-pmic.c?  The driver
> >> will be supporting several PMICs that do not fit the pm8xxx naming scheme.
> >>  One of which is even specified in the compatible list of this driver
> >> (pma8084).  There is presently downstream support for the following PMICs:
> >> PM8019, PM8110, PM8226, PM8841, PM8916, PM8941, PM8994, PMA8084, PMD9635,
> >> PMI8962, and PMI8994 [1].  Four of these do not fit the "PM8XXX" template.
> > 
> > I haven't strong opinion on the file names. The qcom prefix is the one
> > which annoying me. If you look at /drivers/mfd the company name prefixes
> > are very few.
> > 
> > The *compatible* strings are the important thing here. So If MFD
> > maintainer is fine with this name I'm fine too.
> 
> Lee, are you OK with suggested names qcom-spmi-pmic and qcom-ssbi-pmic?

Sounds fine to me.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
