Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932939Ab3GCSFa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:05:30 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:42890 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932575Ab3GCSF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:05:26 -0400
Date: Wed, 3 Jul 2013 21:04:29 +0300
From: Mika Westerberg <mika.westerberg@iki.fi>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        spi-devel-general@lists.sourceforge.net,
        Ryan Mallon <rmallon@gmail.com>, broonie@kernel.org,
        grant.likely@linaro.org, hsweeten@visionengravers.com
Subject: Re: [PATCH v2 05/11] spi: spi-ep93xx: use devm_clk_get()
Message-ID: <20130703180429.GD26568@mwesterb-mobl.lan>
References: <201307021008.22347.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201307021008.22347.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 02, 2013 at 10:08:21AM -0700, H Hartley Sweeten wrote:
> Use devm_clk_get() so that the clk_put() happens automatically when
> the last reference to this driver is dropped.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ryan Mallon <rmallon@gmail.com>
> Cc: Mika Westerberg <mika.westerberg@iki.fi>

Acked-by: Mika Westerberg <mika.westerberg@iki.fi>
