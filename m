Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505AbaDBA0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 20:26:21 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:55870 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbaDBA0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 20:26:19 -0400
MIME-Version: 1.0
X-Originating-IP: [36.239.233.75]
In-Reply-To: <1394250929.3892.1.camel@phoenix>
References: <1394250929.3892.1.camel@phoenix>
Date: Wed, 2 Apr 2014 08:26:18 +0800
Message-ID: <CAFRkauBA0XPQvoqsUkUwHksf4WbEGi=2Ekm-AY82SNmegHDsrg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] regulator: pbias: Fix is_enabled callback implementation
From: Axel Lin <axel.lin@ingics.com>
To: Chris Ball <chris@printf.net>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Balaji T K <balajitk@ti.com>,
        Florian Vaussard <florian.vaussard@epfl.ch>, Stefan Roese <sr@denx.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-03-08 11:55 GMT+08:00 Axel Lin <axel.lin@ingics.com>:
> The is_enabled implementation is wrong in some cases:
> e.g. for pbias_mmc_omap5: enable_mask is : BIT(27) | BIT(25) | BIT(26)
> However, pbias_regulator_enable() only sets BIT(27) | BIT(26) bits.
> So is_enabled callback will always return false in this case.
> Fix the logic to compare the register value with info->enable rather than
> info->enable_mask.
>

Hi Chris,
Would you pick up this patch serial?

Regards,
Axel
