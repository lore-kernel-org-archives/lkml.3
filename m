Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412AbaGIM7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 08:59:41 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:54514 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbaGIM7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 08:59:39 -0400
Date: Wed, 9 Jul 2014 13:59:34 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Ball <chris@printf.net>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        kernel@stlinux.com, linux-mmc <linux-mmc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: Re: [PATCH v3 01/10] mmc: sdhci-st: Intial support for ST SDHCI
 controller
Message-ID: <20140709125934.GA18634@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1401899424-1365-1-git-send-email-peter.griffin@linaro.org>
 <1401899424-1365-2-git-send-email-peter.griffin@linaro.org>
 <CAPDyKFoFNaFpDTVvMF3fbkrgYwUY1_hcbic89JyJzezFDRtN_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDyKFoFNaFpDTVvMF3fbkrgYwUY1_hcbic89JyJzezFDRtN_w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ulf,

On Wed, 09 Jul 2014, Ulf Hansson wrote:

> On 4 June 2014 18:30, Peter Griffin <peter.griffin@linaro.org> wrote:
> > This platform driver adds initial support for the SDHCI host controller
> > found on STMicroelectronics SoCs.
> >
> > It has been tested on STiH41x b2020 platforms currently.
> >
> > Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> > Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> > Acked-by: Lee Jones <lee.jones@linaro.org>
> > Acked-by: Maxime Coquelin <maxime.coquelin@st.com>
> 
> Thanks! Applied for next.

Can you drop this patch for the moment?

I was just rebasing the series for Maxime, and noticed this patch needs a few 
fixups to cope with Russell Kings recent changes in sdhci.c.

regards,

Peter.


