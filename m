Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728Ab3FSITM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 04:19:12 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53707 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756700Ab3FSITG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 04:19:06 -0400
Date: Wed, 19 Jun 2013 09:18:59 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Mark Brown <broonie@kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v2 1/2] mfd: tps65910: Fix crash in i2c_driver .probe
Message-ID: <20130619081859.GA22998@laptop>
References: <1371550481-28126-1-git-send-email-ttynkkynen@nvidia.com>
 <1371550481-28126-2-git-send-email-ttynkkynen@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1371550481-28126-2-git-send-email-ttynkkynen@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Jun 2013, Tuomas Tynkkynen wrote:

> Commit "i2c: core: make it possible to match a pure device tree driver"
> changed semantics of the i2c probing for device tree devices.
> Device tree probed devices now get a NULL i2c_device_id pointer.
> This caused kernel panics due to NULL dereference.
> 
> Moves the of_match_device call from tps65910_parse_dt to .probe to
> allow the chip type to be detected from device tree but with the
> device parameters coming from platform data.
> 
> Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>

Applied with Stephen's Reviewed-by, thanks.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
