Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757753Ab3K0Qzy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 11:55:54 -0500
Received: from mail-vb0-f43.google.com ([209.85.212.43]:62325 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756975Ab3K0Qzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 11:55:52 -0500
MIME-Version: 1.0
In-Reply-To: <1385569457-8650-2-git-send-email-broonie@kernel.org>
References: <1385569457-8650-1-git-send-email-broonie@kernel.org>
	<1385569457-8650-2-git-send-email-broonie@kernel.org>
Date: Wed, 27 Nov 2013 14:55:51 -0200
Message-ID: <CAOMZO5ByMZ3dg0f6MWC+jt5DOxK7WUXhJYyo_hnjCytnCHM7tg@mail.gmail.com>
Subject: Re: [PATCH 2/2] regulator: core: Check for DT every time we check
 full constraints
From: Fabio Estevam <festevam@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Mark Brown <broonie@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 2:24 PM, Mark Brown <broonie@kernel.org> wrote:
> From: Mark Brown <broonie@linaro.org>
>
> Eliminate the gap between DT becoming available and this being used to say
> we have full constraints by checking directly for DT every time we check
> for full constraints. This improves interoperaton with optional regulator
> support.
>
> Signed-off-by: Mark Brown <broonie@linaro.org>

Thanks, Mark.

This makes LVDS on mx6qsabresd functional again.

Tested-by: Fabio Estevam <fabio.estevam@freescale.com>
