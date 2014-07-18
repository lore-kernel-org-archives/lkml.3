Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161062AbaGRNPQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:15:16 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:34390 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965808AbaGRNPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:15:04 -0400
MIME-Version: 1.0
In-Reply-To: <1405613855-27572-5-git-send-email-svarbanov@mm-sol.com>
References: <1405613855-27572-1-git-send-email-svarbanov@mm-sol.com>
	<1405613855-27572-5-git-send-email-svarbanov@mm-sol.com>
Date: Fri, 18 Jul 2014 18:45:01 +0530
Message-ID: <CABu_nUQDWbejZcQqFSJMhCokeMJXBcsCpsiJxz4gBsmtKiyivA@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] mfd: pm8921: rename pm8921-core driver
From: Prakash Burla <burlaprakash.linuxkernel@gmail.com>
To: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Josh Cartwright <joshc@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 9:47 PM, Stanimir Varbanov <svarbanov@mm-sol.com> wrote:
> The pm8921-core driver presently supports pm8921 and pm8058
> Qualcomm PMICs.  To avoid confusion with new generation PMICs
> (like pm8941) rename the pm8921-core driver to more
> appropriate name pm8xxx-ssbi, which reflects better that
> those chips use SSBI interface.
>
> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
> ---
>  drivers/mfd/Kconfig                          |   14 +++++-----
>  drivers/mfd/Makefile                         |    2 +-
>  drivers/mfd/{pm8921-core.c => pm8xxx-ssbi.c} |   38 +++++++++++++-------------
>  3 files changed, 27 insertions(+), 27 deletions(-)
>  rename drivers/mfd/{pm8921-core.c => pm8xxx-ssbi.c} (92%)
 .
 [Nope]
>  MODULE_LICENSE("GPL v2");
> -MODULE_DESCRIPTION("PMIC 8921 core driver");
> +MODULE_DESCRIPTION("PMIC PM8XXX SSBI driver");
>  MODULE_VERSION("1.0");
> -MODULE_ALIAS("platform:pm8921-core");
> +MODULE_ALIAS("platform:pm8xxx-ssbi");
 >How about adding the module author as svarbanov@mm-sol.com/qcom?
      MODULE_AUTHOR("SVARBANOV<svarbanov@mm-sol.com>");
> --
> 1.7.0.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
