Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751178AbaAPFDH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 00:03:07 -0500
Received: from mail-yh0-f48.google.com ([209.85.213.48]:49965 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbaAPFDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 00:03:05 -0500
Date: Wed, 15 Jan 2014 21:03:00 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Xiubo Li <Li.Xiubo@freescale.com>
cc: broonie@kernel.org, lgirdwood@gmail.com, kuninori.morimoto.gx@renesas.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: simple-card: Add snd_card's name parsing from DT
 node support
In-Reply-To: <1389844801-29309-1-git-send-email-Li.Xiubo@freescale.com>
Message-ID: <alpine.DEB.2.02.1401152102330.20635@chino.kir.corp.google.com>
References: <1389844801-29309-1-git-send-email-Li.Xiubo@freescale.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jan 2014, Xiubo Li wrote:

> If the DT is used and the CPU DAI device has only one DAI, the card
> name will be like :
> 
> ALSA device list:
> 	0: 40031000.sai-sgtl5000
> 
> And this name maybe a little ugly to some customers, so here the
> card name parsing from DT node is supported.
> 
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
>  sound/soc/generic/simple-card   | 0
>  sound/soc/generic/simple-card.  | 0
>  sound/soc/generic/simple-card.c | 7 ++++++-
>  3 files changed, 6 insertions(+), 1 deletion(-)
>  create mode 100644 sound/soc/generic/simple-card
>  create mode 100644 sound/soc/generic/simple-card.

Probably not the intention to create these empty files.
