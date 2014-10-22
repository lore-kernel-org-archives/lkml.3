Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbaJVJfF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 05:35:05 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:48280 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754192AbaJVJfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 05:35:02 -0400
Message-ID: <1413970514.30282.8.camel@mm-sol.com>
Subject: Re: [PATCH v5 3/4] pinctrl: Qualcomm SPMI PMIC GPIO pin controller
 driver
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Date: Wed, 22 Oct 2014 12:35:14 +0300
In-Reply-To: <5446A2D8.3070204@linaro.org>
References: <1412181058-29179-1-git-send-email-iivanov@mm-sol.com>
	 <1412181058-29179-4-git-send-email-iivanov@mm-sol.com>
	 <5446A2D8.3070204@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.13.5-fta1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2014-10-21 at 19:15 +0100, Srinivas Kandagatla wrote:
> Hi Ivan,
> 
> Just realized that this patch can generate compiler errors due to 
> 3.18
> changes in pinmux_ops struct and gpiochip_remove returns void now.

Yes. I am just preparing new version of this for Linus.

Regards,
Ivan
