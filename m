Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbaGVKdB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 06:33:01 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:52063 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658AbaGVKc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 06:32:59 -0400
Date: Tue, 22 Jul 2014 11:32:52 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Josh Cartwright <joshc@codeaurora.org>
Subject: Re: [PATCH v2 4/4] mfd: pm8921: rename pm8921-core driver
Message-ID: <20140722103252.GD8406@lee--X1>
References: <1405613855-27572-1-git-send-email-svarbanov@mm-sol.com>
 <1405613855-27572-5-git-send-email-svarbanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1405613855-27572-5-git-send-email-svarbanov@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2014, Stanimir Varbanov wrote:

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

Patch looks fine to me.

  Acked-by: Lee Jones <lee.jones@linaro.org>

I'm assuming we want to wait for the others in the set to be ready
before applying?

[...]

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
