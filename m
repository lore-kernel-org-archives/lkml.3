Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab3LDHjX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 02:39:23 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:50934 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658Ab3LDHjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 02:39:20 -0500
MIME-Version: 1.0
In-Reply-To: <1386053006-6480-4-git-send-email-j-keerthy@ti.com>
References: <1386053006-6480-1-git-send-email-j-keerthy@ti.com>
	<1386053006-6480-4-git-send-email-j-keerthy@ti.com>
Date: Wed, 4 Dec 2013 13:09:20 +0530
Message-ID: <CAKDJKT6TMHEboET4=iVEM2qbi6Bz7kCyyjutLfym2pwrwtEGVg@mail.gmail.com>
Subject: Re: [PATCH 3/4] Regulators: TPS65218: Add Regulator driver for
 TPS65218 PMIC
From: Manish Badarkhe <badarkhe.manish@gmail.com>
To: Keerthy <j-keerthy@ti.com>
Cc: Rob Herring <rob.herring@calxeda.com>, pawel.moll@arm.com,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, ijc+devicetree@hellion.org.uk,
        Rob Landley <rob@landley.net>, sameo@linux.intel.com,
        lee.jones@linaro.org, grant.likely@linaro.org,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Keerthy,

> +       rdev = regulator_register(&regulators[id], &config);

Can you make use of "devm_regulator_register" instead?

> +       if (IS_ERR(rdev)) {
> +               dev_err(tps->dev, "failed to register %s regulator\n",
> +                       pdev->name);
> +               return PTR_ERR(rdev);
> +       }
> +
> +       /* Save regulator */
> +       tps->rdev[id] = rdev;
> +
> +       return 0;
> +}


Best Regards
Manish Badarkhe
