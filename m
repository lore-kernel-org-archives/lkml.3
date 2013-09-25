Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab3IYLTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 07:19:10 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:53792 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096Ab3IYLTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 07:19:08 -0400
Date: Wed, 25 Sep 2013 12:19:03 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH 1/3] mfd: mc13xxx: Don't require lock for simple register
 I/O
Message-ID: <20130925111903.GF5132@lee--X1>
References: <1379960073-23245-1-git-send-email-broonie@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1379960073-23245-1-git-send-email-broonie@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Sep 2013, Mark Brown wrote:

> From: Mark Brown <broonie@linaro.org>
> 
> Since the conversion to regmap there has been no need for device level
> locking for I/O as regmap provides locking so remove the locks.
> 
> Signed-off-by: Mark Brown <broonie@linaro.org>
> ---
>  drivers/mfd/mc13xxx-core.c | 5 -----
>  1 file changed, 5 deletions(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
