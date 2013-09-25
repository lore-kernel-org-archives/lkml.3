Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab3IYLT7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 07:19:59 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:54757 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab3IYLT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 07:19:58 -0400
Date: Wed, 25 Sep 2013 12:19:54 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH 2/3] mfd: mc13xxx: Move SPI erratum workaround into SPI
 I/O function
Message-ID: <20130925111954.GG5132@lee--X1>
References: <1379960073-23245-1-git-send-email-broonie@kernel.org>
 <1379960073-23245-2-git-send-email-broonie@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1379960073-23245-2-git-send-email-broonie@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Sep 2013, Mark Brown wrote:

> From: Mark Brown <broonie@linaro.org>
> 
> Move the workaround for double sending AUDIO_CODEC and AUDIO_DAC writes
> into the SPI core, aiding refactoring to eliminate the ASoC custom I/O
> functions and avoiding the extra writes for I2C.
> 
> Signed-off-by: Mark Brown <broonie@linaro.org>
> ---
>  drivers/mfd/mc13xxx-spi.c   | 5 +++++
>  include/linux/mfd/mc13xxx.h | 7 +++++++
>  sound/soc/codecs/mc13783.c  | 4 ----
>  3 files changed, 12 insertions(+), 4 deletions(-)

I assume this is okay to go in via the MFD tree.

I've applied it until you say otherwise.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
