Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbaLOOOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:14:15 -0500
Received: from tex.lwn.net ([70.33.254.29]:49351 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554AbaLOOOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:14:03 -0500
Date: Mon, 15 Dec 2014 09:13:56 -0500
From: Jonathan Corbet <corbet@lwn.net>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RESEND] [media] VIDEO_CAFE_CCIC should select
 VIDEOBUF2_DMA_SG
Message-ID: <20141215091356.3f03f0d7@lwn.net>
In-Reply-To: <CAMuHMdVGXyGJU1SoTMCX4P5BJEStpYrp0_dJ8TqaPhQTC_-guA@mail.gmail.com>
References: <1418651737-10016-1-git-send-email-geert@linux-m68k.org>
	<20141215090404.6d5cb86e@lwn.net>
	<CAMuHMdVGXyGJU1SoTMCX4P5BJEStpYrp0_dJ8TqaPhQTC_-guA@mail.gmail.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Dec 2014 15:10:38 +0100
Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> If the driver cannot do SG, perhaps this block should be removed from
> drivers/media/platform/marvell-ccic/mcam-core.h?
> 
>     #if IS_ENABLED(CONFIG_VIDEOBUF2_DMA_SG)
>     #define MCAM_MODE_DMA_SG 1
>     #endif

Other drivers using the Marvell core can do S/G, though, so that option
needs to remain.  Applying your patch is almost certainly the most
straightforward solution at this point.

Thanks,

jon
