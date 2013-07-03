Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191Ab3GCSBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:01:38 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:55057 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab3GCSBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:01:37 -0400
Date: Wed, 3 Jul 2013 21:00:39 +0300
From: Mika Westerberg <mika.westerberg@iki.fi>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        spi-devel-general@lists.sourceforge.net,
        Ryan Mallon <rmallon@gmail.com>, broonie@kernel.org,
        grant.likely@linaro.org, hsweeten@visionengravers.com
Subject: Re: [PATCH v2 02/11] spi: spi-ep93xx: use read,write instead of
 __raw_* variants
Message-ID: <20130703180039.GA26568@mwesterb-mobl.lan>
References: <201307021006.26694.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201307021006.26694.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 02, 2013 at 10:06:26AM -0700, H Hartley Sweeten wrote:
> The memory resource used by this driver is ioremap()'d and the normal
> read,write calls can be used instead of the __raw_* variants.
> 
> Also, remove the inline tag on the helper functions and let the compiler
> decide if they are inlined.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ryan Mallon <rmallon@gmail.com>
> Cc: Mika Westerberg <mika.westerberg@iki.fi>

Acked-by: Mika Westerberg <mika.westerberg@iki.fi>
