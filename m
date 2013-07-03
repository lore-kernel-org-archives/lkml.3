Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932820Ab3GCSDJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:03:09 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:57923 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065Ab3GCSDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:03:07 -0400
Date: Wed, 3 Jul 2013 21:02:10 +0300
From: Mika Westerberg <mika.westerberg@iki.fi>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        spi-devel-general@lists.sourceforge.net,
        Ryan Mallon <rmallon@gmail.com>, broonie@kernel.org,
        grant.likely@linaro.org, hsweeten@visionengravers.com
Subject: Re: [PATCH v2 03/11] spi: spi-ep93xx: remove bits_per_word() helper
Message-ID: <20130703180210.GB26568@mwesterb-mobl.lan>
References: <201307021007.01896.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201307021007.01896.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 02, 2013 at 10:07:01AM -0700, H Hartley Sweeten wrote:
> Check t->bits_per_word directly and remove the inline helper function.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ryan Mallon <rmallon@gmail.com>
> Cc: Mika Westerberg <mika.westerberg@iki.fi>

I wonder why the helper was there in the first place.

Acked-by: Mika Westerberg <mika.westerberg@iki.fi>
