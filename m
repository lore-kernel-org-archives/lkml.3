Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199AbaLATKF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 14:10:05 -0500
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:59317 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932175AbaLATKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 14:10:03 -0500
Message-ID: <1417461001.30245.35.camel@x220>
Subject: Re: [PATCH] ASoC: snd-soc-afeb9260: delete driver as board has just
 been removed
From: Paul Bolle <pebolle@tiscali.nl>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        lgirdwood@gmail.com, broonie@kernel.org, alsa-devel@alsa-project.org,
        slapin@ossfans.org, Bo Shen <voice.shen@atmel.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Date: Mon, 01 Dec 2014 20:10:01 +0100
In-Reply-To: <1417449472-13498-1-git-send-email-nicolas.ferre@atmel.com>
References: <1417449472-13498-1-git-send-email-nicolas.ferre@atmel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Dec 2014 19:10:02.0415 (UTC) FILETIME=[689033F0:01D00D9A]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicholas,

On Mon, 2014-12-01 at 16:57 +0100, Nicolas Ferre wrote:
> During the removal of all AT91 !DT boards, we removed the AFEB9260. This driver
> is !DT and was only used by this board, so we delete it as well.
> 
> Reported-by: Paul Bolle <pebolle@tiscali.nl>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>  sound/soc/atmel/Makefile           |   1 -
>  sound/soc/atmel/snd-soc-afeb9260.c | 151 -------------------------------------
>  2 files changed, 152 deletions(-)
>  delete mode 100644 sound/soc/atmel/snd-soc-afeb9260.c

This doesn't touch the entry for SND_AT91_SOC_AFEB9260 in
sound/soc/atmel/Kconfig. That doesn't look right to me.

Thanks,


Paul Bolle

