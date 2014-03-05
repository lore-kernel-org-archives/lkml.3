Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833AbaCEQEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 11:04:51 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:57392 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657AbaCEQE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 11:04:29 -0500
Message-ID: <53174AFD.2040907@gmail.com>
Date: Wed, 05 Mar 2014 17:04:13 +0100
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org
CC: kyungmin.park@samsung.com, kishon@ti.com, t.figa@samsung.com,
        s.nawrocki@samsung.com, m.szyprowski@samsung.com,
        gautam.vivek@samsung.com, mat.krawczuk@gmail.com,
        yulgon.kim@samsung.com, p.paneri@samsung.com,
        av.tikhomirov@samsung.com, jg1.han@samsung.com, galak@codeaurora.org,
        matt.porter@linaro.org, tjakobi@math.uni-bielefeld.de,
        stern@rowland.harvard.edu, sander@humilis.net
Subject: Re: [PATCH v9 2/4] phy: core: Add devm_of_phy_get to phy-core
References: <1394033288-5551-1-git-send-email-k.debski@samsung.com> <1394033288-5551-3-git-send-email-k.debski@samsung.com>
In-Reply-To: <1394033288-5551-3-git-send-email-k.debski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.03.2014 16:28, Kamil Debski wrote:
> Adding devm_of_phy_get will allow to get phys by supplying a
> pointer to the struct device_node instead of struct device.
>
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> ---
>   drivers/phy/phy-core.c  |   31 +++++++++++++++++++++++++++++++
>   include/linux/phy/phy.h |    8 ++++++++
>   2 files changed, 39 insertions(+)

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz
