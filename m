Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab3LJJSu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 04:18:50 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:36699 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab3LJJSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 04:18:39 -0500
MIME-Version: 1.0
In-Reply-To: <1386666583-3280-1-git-send-email-k.kozlowski@samsung.com>
References: <1386666583-3280-1-git-send-email-k.kozlowski@samsung.com>
Date: Tue, 10 Dec 2013 14:48:38 +0530
Message-ID: <CAK9yfHwz0Swi=vBu_Wynsr5ZDMDfwnFxS1p2Sc6ofabiotEa1w@mail.gmail.com>
Subject: Re: [TRIVIAL PATCH 1/2] regulator: s5m8767: Define symbol for buck
 control mask
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Jiri Kosina <trivial@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

On 10 December 2013 14:39, Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:

>  static int s5m8767_reg_disable(struct regulator_dev *rdev)
>  {
>         struct s5m8767_info *s5m8767 = rdev_get_drvdata(rdev);
>         int ret, reg;
> -       int  mask = 0xc0, enable_ctrl;
> +       int mask = S5M8767_ENCTRL_MASK, enable_ctrl;

Couldn't we get rid of this mask variable here too?

Otherwise the patch looks good to me.

-- 
With warm regards,
Sachin
