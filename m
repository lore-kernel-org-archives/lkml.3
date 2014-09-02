Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbaIBQaw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 12:30:52 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:5064 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751295AbaIBQau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 12:30:50 -0400
Date: Tue, 2 Sep 2014 09:30:49 -0700
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Georgi Djakov <gdjakov@mm-sol.com>
CC: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "agross@codeaurora.org" <agross@codeaurora.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        "iivanov@mm-sol.com" <iivanov@mm-sol.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v3 1/4] pinctrl: qcom: Add APQ8084 pinctrl support
Message-ID: <20140902163047.GL12494@sonymobile.com>
References: <1409663625-3185-1-git-send-email-gdjakov@mm-sol.com>
 <1409663625-3185-2-git-send-email-gdjakov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1409663625-3185-2-git-send-email-gdjakov@mm-sol.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 02 Sep 06:13 PDT 2014, Georgi Djakov wrote:

> This patchset adds pinctrl support for the Qualcomm APQ8084 platform.
> 
> Reviewed-by: Andy Gross <agross@codeaurora.org>
> Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>

I was expecting patch 4 to come before this, so that this commit would be
"complete". But I'm fine with this.

Acked-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>

