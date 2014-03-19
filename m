Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759059AbaCSDqz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 23:46:55 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:61623 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758890AbaCSDqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 23:46:54 -0400
MIME-Version: 1.0
In-Reply-To: <1395147470-24817-1-git-send-email-k.kozlowski@samsung.com>
References: <1395147470-24817-1-git-send-email-k.kozlowski@samsung.com>
Date: Wed, 19 Mar 2014 09:16:53 +0530
Message-ID: <CAK9yfHx=3KR0WyrtmZXbYJ3MXM9vAsCzh=EKORfiifzhL2Ud8Q@mail.gmail.com>
Subject: Re: [PATCH] mfd: sec-core: Fix I2C dummy device resource leak on
 probe failure
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 March 2014 18:27, Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:
> Dummy I2C device allocated in sec_pmic_probe() leaked if
> devm_regmap_init_i2c() failed. Unregister it before returning from
> probe.
>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Looks good.
Reviewed-by: Sachin Kamat <sachin.kamat@linaro.org>

-- 
With warm regards,
Sachin
