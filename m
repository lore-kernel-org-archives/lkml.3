Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399AbaAMLpM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 06:45:12 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:47344 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbaAMLpI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 06:45:08 -0500
X-Auth-Info: ua8q8sI3UfsQNfQHUmPoipFsLNcHO4YqhKkd+8SJ3h0=
From: Marek Vasut <marex@denx.de>
To: Lothar =?iso-8859-1?q?Wa=DFmann?= <LW@karo-electronics.de>
Subject: Re: [PATCH] imx-drm: parallel-display: honor 'native-mode' property when selecting video mode from DT
Date: Mon, 13 Jan 2014 12:43:57 +0100
User-Agent: KMail/1.13.7 (Linux/3.10-2-amd64; KDE/4.10.5; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jiada Wang <jiada_wang@mentor.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
References: <1389608673-10565-1-git-send-email-LW@KARO-electronics.de>
In-Reply-To: <1389608673-10565-1-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201401131243.57573.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 13, 2014 at 11:24:33 AM, Lothar Waﬂmann wrote:
> This patch allows to select a specific video mode from a list of modes
> defined in DT by setting the 'native-mode' property appropriately.
> 
> Since all current users of this driver have only one mode defined in
> their .dts files, the patch does not change the behaviour of this
> driver on the affected platforms.
> 
> Signed-off-by: Lothar Waﬂmann <LW@KARO-electronics.de>

Looks OK to me, thanks.

Reviewed-by: Marek Vasut <marex@denx.de>

Best regards,
Marek Vasut
