Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965588AbaFSWrB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 18:47:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52488 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964958AbaFSWrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 18:47:00 -0400
Date: Thu, 19 Jun 2014 15:51:00 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Grant Likely <grant.likely@linaro.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        devel@driverdev.osuosl.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH] staging: imx-drm: ipu-v3: ipu-common.c: Cleaning up
 return of uninitialized variable
Message-ID: <20140619225100.GA15258@kroah.com>
References: <1402788921-15458-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <1402788921-15458-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402788921-15458-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2014 at 01:35:21AM +0200, Rickard Strandqvist wrote:
> Before when there was an error a uninitialized variable would be returnd.
> Now it returns -ENODEV
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/staging/imx-drm/ipu-v3/ipu-common.c |    4 ++--

This file isn't even in the tree anymore, what did you make this patch
against?
