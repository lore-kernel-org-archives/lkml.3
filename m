Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbaGUHqg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 03:46:36 -0400
Received: from mail-yh0-f44.google.com ([209.85.213.44]:39016 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbaGUHqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 03:46:33 -0400
Date: Mon, 21 Jul 2014 08:46:27 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Prakash Burla <burlaprakash.linuxkernel@gmail.com>
Cc: Stanimir Varbanov <svarbanov@mm-sol.com>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Josh Cartwright <joshc@codeaurora.org>
Subject: Re: [PATCH v2 4/4] mfd: pm8921: rename pm8921-core driver
Message-ID: <20140721074627.GT30888@lee--X1>
References: <1405613855-27572-1-git-send-email-svarbanov@mm-sol.com>
 <1405613855-27572-5-git-send-email-svarbanov@mm-sol.com>
 <CABu_nUQDWbejZcQqFSJMhCokeMJXBcsCpsiJxz4gBsmtKiyivA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABu_nUQDWbejZcQqFSJMhCokeMJXBcsCpsiJxz4gBsmtKiyivA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2014, Prakash Burla wrote:
> On Thu, Jul 17, 2014 at 9:47 PM, Stanimir Varbanov <svarbanov@mm-sol.com> wrote:
> > The pm8921-core driver presently supports pm8921 and pm8058
> > Qualcomm PMICs.  To avoid confusion with new generation PMICs
> > (like pm8941) rename the pm8921-core driver to more
> > appropriate name pm8xxx-ssbi, which reflects better that
> > those chips use SSBI interface.
> >
> > Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
> > ---
> >  drivers/mfd/Kconfig                          |   14 +++++-----
> >  drivers/mfd/Makefile                         |    2 +-
> >  drivers/mfd/{pm8921-core.c => pm8xxx-ssbi.c} |   38 +++++++++++++-------------
> >  3 files changed, 27 insertions(+), 27 deletions(-)
> >  rename drivers/mfd/{pm8921-core.c => pm8xxx-ssbi.c} (92%)
>  .
>  [Nope]

What does this mean?

> >  MODULE_LICENSE("GPL v2");
> > -MODULE_DESCRIPTION("PMIC 8921 core driver");
> > +MODULE_DESCRIPTION("PMIC PM8XXX SSBI driver");
> >  MODULE_VERSION("1.0");
> > -MODULE_ALIAS("platform:pm8921-core");
> > +MODULE_ALIAS("platform:pm8xxx-ssbi");
>  >How about adding the module author as svarbanov@mm-sol.com/qcom?
>       MODULE_AUTHOR("SVARBANOV<svarbanov@mm-sol.com>");

Module author has the same standards as Git author.

MODULE_AUTHOR("Stanimir Varbanov <svarbanov@mm-sol.com>");

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
