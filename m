Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbaDGPXf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 11:23:35 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:43872 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575AbaDGPXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 11:23:32 -0400
Message-ID: <1396884150.28420.38.camel@iivanov-dev>
Subject: Re: [PATCH v2] clk: qcom: Add support for IPQ8064's global clock
 controller (GCC)
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Kumar Gala <galak@codeaurora.org>
Cc: Mike Turquette <mturquette@linaro.org>, devicetree@vger.kernel.org,
        sboyd@codeaurora.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Date: Mon, 07 Apr 2014 18:22:30 +0300
In-Reply-To: <AF6AA9C9-6A47-4394-91FD-F7F0C264C530@codeaurora.org>
References: <1396642749-12979-1-git-send-email-galak@codeaurora.org>
	 <1396882918.28420.37.camel@iivanov-dev>
	 <AF6AA9C9-6A47-4394-91FD-F7F0C264C530@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.1-2ubuntu2~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-07 at 10:10 -0500, Kumar Gala wrote:
> On Apr 7, 2014, at 10:01 AM, Ivan T. Ivanov <iivanov@mm-sol.com> wrote:
> 
> > Hi Kumar,

<snip>
> > 
> >> --- /dev/null
> >> +++ b/drivers/clk/qcom/gcc-ipq806x.c
> >> @@ -0,0 +1,1957 @@
> >> +/*

<snip>

> >> +#include <dt-bindings/clock/qcom,gcc-ipq806x.h>
> >> +#include <dt-bindings/reset/qcom,gcc-ipq806x.h>
> >> +
> >> +#include "common.h"
> > 
> > Do I miss something or this file is not available?
> 
> Its based on Stephen’s refactoring patch:
> 
> https://patchwork.kernel.org/patch/3876761/
> 

Thanks, 
Ivan

> - k
> 


