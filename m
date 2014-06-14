Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbaFNTeO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 15:34:14 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:47222 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbaFNTeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 15:34:11 -0400
X-Auth-Info: 4ecIPGH8jKAuMgdVzbc+mnNg65RSaeN3JGK2QGS7NLQ=
From: Marek Vasut <marex@denx.de>
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH v3 2/4] crypto: Update makefile and Kconfig for Security System
Date: Sat, 14 Jun 2014 21:01:30 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.13.1; x86_64; ; )
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, maxime.ripard@free-electrons.com,
        linux@arm.linux.org.uk, herbert@gondor.apana.org.au,
        davem@davemloft.net, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-sunxi@googlegroups.com
References: <1402404197-4236-1-git-send-email-clabbe.montjoie@gmail.com> <1402404197-4236-3-git-send-email-clabbe.montjoie@gmail.com>
In-Reply-To: <1402404197-4236-3-git-send-email-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201406142101.30546.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 10, 2014 at 02:43:15 PM, LABBE Corentin wrote:
> Add necessary changes for configuring and compiling the Security System
> driver.
> 
> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
> ---
>  drivers/crypto/Kconfig  | 91
> +++++++++++++++++++++++++++++++++++++++++++++++++ drivers/crypto/Makefile
> |  1 +
>  2 files changed, 92 insertions(+)

This should be part of 1/4, otherwise 1/4 just adds dead code.

Best regards,
Marek Vasut
