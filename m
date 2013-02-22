Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758445Ab3BVRZr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 12:25:47 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:41725 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757765Ab3BVRZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 12:25:44 -0500
Message-ID: <5127AA15.9030900@linaro.org>
Date: Fri, 22 Feb 2013 09:25:41 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tushar Behera <tushar.behera@linaro.org>
CC: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com, patches@linaro.org
Subject: Re: [PATCH] ARM: EXYNOS: Keep USB related LDOs always active on Origen
References: <51271673.9090003@linaro.org> <1361515707-8571-1-git-send-email-tushar.behera@linaro.org>
In-Reply-To: <1361515707-8571-1-git-send-email-tushar.behera@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2013 10:48 PM, Tushar Behera wrote:
> LDO3 and LDO8 are used for powering both device and host phy controllers.
> These regulators are not handled in USB host driver. Hence we get
> unexpected behaviour when the regulators are disabled elsewhere.
>
> It would be best to keep these regulators always on.
>
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> ---
>
> Based on v3.8.

This works great for me! Thanks so much Tushar!

Tested-by: John Stultz <john.stultz@linaro.org>


