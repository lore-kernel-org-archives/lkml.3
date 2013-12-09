Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760855Ab3LIIYp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 03:24:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48027 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215Ab3LIIYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 03:24:41 -0500
Date: Sun, 8 Dec 2013 17:39:56 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Nicolin Chen <b42378@freescale.com>
Cc: akpm@linux-foundation.org, joe@perches.com, nsekhar@ti.com,
        khilman@deeprootsystems.com, linux@arm.linux.org.uk,
        dan.j.williams@intel.com, vinod.koul@intel.com, m.chehab@samsung.com,
        hjk@hansjkoch.de, perex@perex.cz, tiwai@suse.de, lgirdwood@gmail.com,
        broonie@kernel.org, rmk+kernel@arm.linux.org.uk, eric.y.miao@gmail.com,
        haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        linux-media@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH][RESEND 5/8] uio: uio_pruss: use gen_pool_dma_alloc() to
 allocate sram memory
Message-ID: <20131209013956.GA5385@kroah.com>
References: <cover.1383306365.git.b42378@freescale.com>
 <f26a7fd466d22aaaeae9cf32d3c4c43c333e0b35.1383306365.git.b42378@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f26a7fd466d22aaaeae9cf32d3c4c43c333e0b35.1383306365.git.b42378@freescale.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01, 2013 at 07:48:18PM +0800, Nicolin Chen wrote:
> Since gen_pool_dma_alloc() is introduced, we implement it to simplify code.
> 
> Signed-off-by: Nicolin Chen <b42378@freescale.com>
> ---

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
