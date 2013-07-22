Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654Ab3GVWhb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 18:37:31 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:50008 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3GVWh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 18:37:29 -0400
X-Auth-Info: juR8821ljYieVSk4DpF4jagjHfTPH7uj1MduRv6T7oo=
From: Marek Vasut <marex@denx.de>
To: Hector Palacios <hector.palacios@digi.com>
Subject: Re: [PATCH v3 5/5] iio: mxs-lradc: add write_raw function to modify scale
Date: Tue, 23 Jul 2013 00:37:29 +0200
User-Agent: KMail/1.13.7 (Linux/3.9-1-amd64; KDE/4.8.4; x86_64; ; )
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        alexandre.belloni@free-electrons.com, jic23@kernel.org,
        lars@metafoo.de, fabio.estevam@freescale.com
References: <1374501843-19651-1-git-send-email-hector.palacios@digi.com> <1374501843-19651-6-git-send-email-hector.palacios@digi.com>
In-Reply-To: <1374501843-19651-6-git-send-email-hector.palacios@digi.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201307230037.29504.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Hector Palacios,

> Added write_raw function to manipulate the optional divider_by_two
> through the scaling attribute out of the available scales.
> 
> Signed-off-by: Hector Palacios <hector.palacios@digi.com>
> ---

Yep, looks nicer,

Reviewed-by: Marek Vasut <marex@denx.de>

Best regards,
Marek Vasut
