Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbaJGJBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 05:01:49 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:48628 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752825AbaJGJBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 05:01:45 -0400
Message-ID: <1412672510.1027.57.camel@iivanov-dev>
Subject: Re: [PATCH 0/2] Qualcomm PM8941 power key driver
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Date: Tue, 07 Oct 2014 12:01:50 +0300
In-Reply-To: <1412644321-27683-1-git-send-email-bjorn.andersson@sonymobile.com>
References: <1412644321-27683-1-git-send-email-bjorn.andersson@sonymobile.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Bjorn,

On Mon, 2014-10-06 at 18:11 -0700, Bjorn Andersson wrote:
> These patches add dt bindings and a device driver for the power key block in
> the Qualcomm PM8941 pmic.
> 
> Courtney Cavin (2):
>   input: Add Qualcomm PM8941 power key driver
>   input: pm8941-pwrkey: Add DT binding documentation
> 
>  .../bindings/input/qcom,pm8941-pwrkey.txt          |   43 +++++
>  drivers/input/misc/Kconfig                         |   12 ++
>  drivers/input/misc/Makefile                        |    1 +
>  drivers/input/misc/pm8941-pwrkey.c                 |  196 ++++++++++++++++++++
>  4 files changed, 252 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/input/qcom,pm8941-pwrkey.txt
>  create mode 100644 drivers/input/misc/pm8941-pwrkey.c

Any reason why we cannot reuse pm8xxx-pwrkey driver? It have been
converted to regmap already. 

Regards,
Ivan 


