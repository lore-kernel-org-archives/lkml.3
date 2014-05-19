Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbaESII1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 04:08:27 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:46945 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772AbaESIIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 04:08:25 -0400
Message-ID: <1400486858.1464.11.camel@iivanov-dev>
Subject: Re: [PATCH 1/4] spi: qup: Remove chip select function
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Andy Gross <agross@codeaurora.org>
Cc: Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Date: Mon, 19 May 2014 11:07:38 +0300
In-Reply-To: <1400016884-9568-2-git-send-email-agross@codeaurora.org>
References: <1400016884-9568-1-git-send-email-agross@codeaurora.org>
	 <1400016884-9568-2-git-send-email-agross@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.1-2ubuntu2~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Andy,

On Tue, 2014-05-13 at 16:34 -0500, Andy Gross wrote:
> This patch removes the chip select function.  Chip select should instead be
> supported using GPIOs, defining the DT entry "cs-gpios", and letting the SPI
> core assert/deassert the chip select as it sees fit.
> 
> Signed-off-by: Andy Gross <agross@codeaurora.org>

<snip>

> +- num-cs:	total number of chipselects

My understanding is that "num-cs" have to be parsed by
master driver, not by core SPI driver.

> -
> -	/* Disable auto CS toggle and use manual */
> -	iocontol &= ~SPI_IO_C_MX_CS_MODE;

Probably we should keep this?

Regards,
Ivan

