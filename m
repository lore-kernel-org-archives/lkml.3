Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315AbaIQAup (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 20:50:45 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:48775 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbaIQAuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 20:50:44 -0400
X-Auth-Info: hWvJoVnza2i8wTqEplZItnk6u84HMhldYx66MEYnxyE=
From: Marek Vasut <marex@denx.de>
To: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v6] spi: spi-imx: add DMA support
Date: Wed, 17 Sep 2014 02:49:17 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.13.1; x86_64; ; )
Cc: Robin Gong <b38343@freescale.com>, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, Frank.Li@freescale.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org
References: <1410398324-15284-1-git-send-email-b38343@freescale.com> <20140915223944.GH7960@sirena.org.uk>
In-Reply-To: <20140915223944.GH7960@sirena.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201409170249.17597.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 16, 2014 at 12:39:44 AM, Mark Brown wrote:
> On Thu, Sep 11, 2014 at 09:18:44AM +0800, Robin Gong wrote:
> > Enable DMA support on i.mx6. The read speed can increase from 600KB/s
> > to 1.2MB/s on i.mx6q. You can disable or enable dma function in dts.
> > If not set "dma-names" in dts, spi will use PIO mode. This patch only
> > validate on i.mx6, not i.mx5, but encourage ones to apply this patch
> > on i.mx5 since they share the same IP.
> 
> Adding Maerk (who I had to add to earlier versions of this patch).

Looks OK to me.

Acked-by: Marek Vasut <marex@denx.de>

Thank you!

Best regards,
Marek Vasut
