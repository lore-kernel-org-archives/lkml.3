Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbaKDO4J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 09:56:09 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:55780 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839AbaKDO4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 09:56:06 -0500
MIME-Version: 1.0
In-Reply-To: <1415108003-16387-1-git-send-email-iivanov@mm-sol.com>
References: <1415108003-16387-1-git-send-email-iivanov@mm-sol.com>
Date: Tue, 4 Nov 2014 12:56:02 -0200
Message-ID: <CAOMZO5Bkmqmm6Fe-iKHbnZS=1f3TQKQ0E4+XMOk1XqCaEeuW_g@mail.gmail.com>
Subject: Re: [PATCH] mfd: qcom-spmi-pmic: Add support for more chips versions
From: Fabio Estevam <festevam@gmail.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 4, 2014 at 11:33 AM, Ivan T. Ivanov <iivanov@mm-sol.com> wrote:

> +       ret = regmap_read(map, PMIC_SUBTYPE, &subtype);
> +       if (ret < 0)
> +               return ret;
> +
> +       rev2 = regmap_read(map, PMIC_REV2, &rev2);
> +       if (ret < 0)
> +               return ret;

I think you meant:
ret = regmap_read(map, PMIC_REV2, &rev2);

> +
> +       rev3 = regmap_read(map, PMIC_REV3, &rev3);

Likewise.

> +       if (ret < 0)
> +               return ret;
> +
> +       rev4 = regmap_read(map, PMIC_REV4, &rev4);

Likewise.

> +       if (ret < 0)
> +               return ret;
