Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218AbbA2Bm6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:42:58 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:37648 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756995AbbA2Bmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:42:53 -0500
Date: Wed, 28 Jan 2015 11:27:27 -0600
From: Andy Gross <agross@codeaurora.org>
To: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        devicetree@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        linux-soc@vger.kernel.org
Subject: Re: [PATCH 1/6] soc: qcom: gsbi: Add support for ADM CRCI muxing
Message-ID: <20150128172727.GB17315@qualcomm.com>
References: <1422396644-21714-1-git-send-email-agross@codeaurora.org>
 <1422396644-21714-2-git-send-email-agross@codeaurora.org>
 <54C8A66E.3070306@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C8A66E.3070306@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 11:05:50AM +0200, Stanimir Varbanov wrote:
> <snip>
> 
> > diff --git a/drivers/soc/qcom/Kconfig b/drivers/soc/qcom/Kconfig
> > index 7bd2c94..32f20be 100644
> > --- a/drivers/soc/qcom/Kconfig
> > +++ b/drivers/soc/qcom/Kconfig
> > @@ -4,6 +4,7 @@
> >  config QCOM_GSBI
> >          tristate "QCOM General Serial Bus Interface"
> >          depends on ARCH_QCOM
> > +	select MFD_SYSCON
> 
> Wrong indentation? In fact the original Kconfig entry has spaces instead
> of tabs, could you prepare a cleanup patch for this.

yeah I'll switch to spaces since the Kconfig is using spaces.

> >          help
> >            Say y here to enable GSBI support.  The GSBI provides control
> >            functions for connecting the underlying serial UART, SPI, and I2C

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

