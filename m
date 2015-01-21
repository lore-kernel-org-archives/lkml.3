Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100AbbAUG3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 01:29:17 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:60131 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076AbbAUG3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 01:29:12 -0500
Date: Tue, 20 Jan 2015 22:29:02 -0800
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: Zidan Wang <zidan.wang@freescale.com>, Timur Tabi <timur@tabi.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Xiubo.Lee@gmail.com, Takashi Iwai <tiwai@suse.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [alsa-devel] [PATCH 0/3] Add master mode, tmd and right-j mode
 support
Message-ID: <20150121062901.GA4350@Alpha>
References: <1421756480-7055-1-git-send-email-zidan.wang@freescale.com>
 <CAOMZO5DcpSsRi4UE8gCjT+w=OueB1pWtQPYphgeEsMNZ_EvK5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5DcpSsRi4UE8gCjT+w=OueB1pWtQPYphgeEsMNZ_EvK5w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 11:15:54PM -0200, Fabio Estevam wrote:

> Not related to your series, but do you have a patch for imx6sx-sdb.dts
> that adds sai support?
> 
> In the FSL version they use 'fsl,sdma-event-remap' property to specify
> the SAI sdma channels, but this is not present in mainline? How are
> you dealing with it?

I think he must have those patches applied to his own local branch
as I do :)

I was quite hesitating to send them because the SDMA one doesn't
look flawless, plus I don't know SDMA owner's plan for upstream.

Nicolin
