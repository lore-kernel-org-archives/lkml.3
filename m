Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757881AbaGAOCe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 10:02:34 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:58604 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756349AbaGAOCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 10:02:33 -0400
Date: Tue, 1 Jul 2014 15:02:26 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: sbkim73@samsung.com, sameo@linux.intel.com, broonie@kernel.org,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: Re: [PATCHv8 2/4] regulator: s2mps11: Add support S2MPU02 regulator
 device
Message-ID: <20140701140226.GJ27971@lee--X1>
References: <1403680487-12141-1-git-send-email-cw00.choi@samsung.com>
 <1403680487-12141-3-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1403680487-12141-3-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jun 2014, Chanwoo Choi wrote:

> This patch add S2MPU02 regulator device to existing S2MPS11 device driver
> because of little difference between S2MPS1x and S2MPU02. The S2MPU02
> regulator device includes LDO[1-28] and BUCK[1-7].
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> [Add missing linear_min_sel of S2MPU02 LDO regulators by Jonghwa Lee]
> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Acked-by: Mark Brown <broonie@linaro.org>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mfd/sec-core.c      |  25 ++++
>  drivers/regulator/s2mps11.c | 321 +++++++++++++++++++++++++++++++++++++++++--

Why are these change munged into one patch?  Shouldn't the MFD changes
really be in patch 1?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
