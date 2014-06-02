Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbaFBHMK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 03:12:10 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:65126 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbaFBHMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 03:12:08 -0400
Message-ID: <538C23C3.8000100@linaro.org>
Date: Mon, 02 Jun 2014 08:12:03 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Ulf Hansson <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org,
        Chris Ball <chris@printf.net>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linus.walleij@linaro.org
Subject: Re: [PATCH v5 02/13] mmc: mmci: convert register bits to use BIT()
 macro.
References: <1401469918-26817-1-git-send-email-srinivas.kandagatla@linaro.org> <1401469980-26906-1-git-send-email-srinivas.kandagatla@linaro.org> <20140531123502.GB20736@n2100.arm.linux.org.uk>
In-Reply-To: <20140531123502.GB20736@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Russell,

On 31/05/14 13:35, Russell King - ARM Linux wrote:
> because allegedly it makes it more "readable".  I don't see much benefit
> to this patch.
Ok, I will drop this patch in next version.

thanks,
srini

