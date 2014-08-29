Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701AbaH2FaS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 01:30:18 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:41500 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbaH2FaP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 01:30:15 -0400
MIME-Version: 1.0
In-Reply-To: <1409057156-1201-2-git-send-email-gdjakov@mm-sol.com>
References: <1409057156-1201-1-git-send-email-gdjakov@mm-sol.com>
	<1409057156-1201-2-git-send-email-gdjakov@mm-sol.com>
Date: Fri, 29 Aug 2014 07:30:15 +0200
Message-ID: <CACRpkdYj3n-N58OLd7Qom1LTDQ3=3KWY4m39zmPxrKjJow=f1w@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] pinctrl: qcom: Add APQ8084 pinctrl support
From: Linus Walleij <linus.walleij@linaro.org>
To: Georgi Djakov <gdjakov@mm-sol.com>,
        Bjorn Andersson <Bjorn.Andersson@sonymobile.com>
Cc: Kumar Gala <galak@codeaurora.org>, Andy Gross <agross@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 2:45 PM, Georgi Djakov <gdjakov@mm-sol.com> wrote:

> This patchset adds pinctrl support for the Qualcomm APQ8084 platform.
>
> Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>

Looks good to me, but waiting for Björn's review before
merging.

Yours,
Linus Walleij
