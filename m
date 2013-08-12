Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab3HMFLO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 01:11:14 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:57472 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476Ab3HMFLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 01:11:13 -0400
X-Auth-Info: 7hY2WqoQmu1Ol7/rvCD3QU07vpfGcYyN/rwSU5IVNGQ=
From: Marek Vasut <marex@denx.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH] m25p80 / fast read
Date: Mon, 12 Aug 2013 22:13:08 +0200
User-Agent: KMail/1.13.7 (Linux/3.9-1-amd64; KDE/4.8.4; x86_64; ; )
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        kernel@pengutronix.de
References: <1376302946-11534-1-git-send-email-s.hauer@pengutronix.de>
In-Reply-To: <1376302946-11534-1-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201308122213.09110.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sascha Hauer,

> The following adds support for the mr25h10 chip to to the m25p80
> driver.
> 
> This driver currently has the problem that it unconditionally uses
> the fast_read command once it's enabled in Kconfig which of course
> leads to problems with multiboard kernels. This series adds a flag
> to the chip specific data to solve this. Also some unnecessary ifdefs
> are removed.
> 
> Sascha

Went through the whole series,

Acked-by: Marek Vasut <marex@denx.de>

Thanks!

Best regards,
Marek Vasut
