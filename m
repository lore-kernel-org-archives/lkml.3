Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbbANVo1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 16:44:27 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:62128 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772AbbANVoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 16:44:25 -0500
MIME-Version: 1.0
In-Reply-To: <1421176167-7180-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1421176167-7180-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Wed, 14 Jan 2015 16:44:24 -0500
Message-ID: <CADnq5_MOFO6FTd-nqGfynhMWTzzTAhnWpS1+qsX3eLaVh_scTg@mail.gmail.com>
Subject: Re: [PATCH] drm/radeon/radeon_i2c: Remove unused function
From: Alex Deucher <alexdeucher@gmail.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 2:09 PM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:
> Remove the function radeon_best_encoder() that is not used anywhere.
>
> This was partially found by using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Applied.  thanks!

Alex

> ---
>  drivers/gpu/drm/radeon/radeon_i2c.c  |    5 -----
>  drivers/gpu/drm/radeon/radeon_mode.h |    2 --
>  2 files changed, 7 deletions(-)
>
> diff --git a/drivers/gpu/drm/radeon/radeon_i2c.c b/drivers/gpu/drm/radeon/radeon_i2c.c
> index add6220..9590bcd 100644
> --- a/drivers/gpu/drm/radeon/radeon_i2c.c
> +++ b/drivers/gpu/drm/radeon/radeon_i2c.c
> @@ -1048,11 +1048,6 @@ struct radeon_i2c_chan *radeon_i2c_lookup(struct radeon_device *rdev,
>         return NULL;
>  }
>
> -struct drm_encoder *radeon_best_encoder(struct drm_connector *connector)
> -{
> -       return NULL;
> -}
> -
>  void radeon_i2c_get_byte(struct radeon_i2c_chan *i2c_bus,
>                          u8 slave_addr,
>                          u8 addr,
> diff --git a/drivers/gpu/drm/radeon/radeon_mode.h b/drivers/gpu/drm/radeon/radeon_mode.h
> index 04db2fd..66c17e3 100644
> --- a/drivers/gpu/drm/radeon/radeon_mode.h
> +++ b/drivers/gpu/drm/radeon/radeon_mode.h
> @@ -740,8 +740,6 @@ extern void radeon_router_select_ddc_port(struct radeon_connector *radeon_connec
>  extern void radeon_router_select_cd_port(struct radeon_connector *radeon_connector);
>  extern bool radeon_ddc_probe(struct radeon_connector *radeon_connector, bool use_aux);
>
> -extern struct drm_encoder *radeon_best_encoder(struct drm_connector *connector);
> -
>  extern bool radeon_atombios_get_ppll_ss_info(struct radeon_device *rdev,
>                                              struct radeon_atom_ss *ss,
>                                              int id);
> --
> 1.7.10.4
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
