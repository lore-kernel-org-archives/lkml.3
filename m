Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbaAFLpv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 06:45:51 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:35737 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbaAFLpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 06:45:49 -0500
Date: Mon, 6 Jan 2014 11:45:44 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Vince Hsu <vinceh@nvidia.com>
Subject: Re: [PATCH 1/2] regulator: as3722: detect SD0 low-voltage mode
Message-ID: <20140106114544.GA30156@lee--X1>
References: <1388094527-7585-1-git-send-email-abrestic@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1388094527-7585-1-git-send-email-abrestic@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Dec 2013, Andrew Bresticker wrote:

> SD0 may operate in low-voltage mode, with a minimum of 0.41V
> and a maximum of 1.5V.  This is indicated by bit 4 of FUSE7.
> 
> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
> Signed-off-by: Vince Hsu <vinceh@nvidia.com>
> ---
>  drivers/regulator/as3722-regulator.c | 30 ++++++++++++++++++++++++++----
>  include/linux/mfd/as3722.h           |  4 ++++
>  2 files changed, 30 insertions(+), 4 deletions(-)

For the MFD part:
  Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
