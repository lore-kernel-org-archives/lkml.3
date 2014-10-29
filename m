Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933180AbaJ2NxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 09:53:18 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:53865 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932837AbaJ2NxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 09:53:16 -0400
MIME-Version: 1.0
In-Reply-To: <1414590424-25585-1-git-send-email-d.lavnikevich@sam-solutions.com>
References: <1414590424-25585-1-git-send-email-d.lavnikevich@sam-solutions.com>
Date: Wed, 29 Oct 2014 11:53:14 -0200
Message-ID: <CAOMZO5BqtahE41aFXS0878QHHjYNqFtR5okLa5Jgf5L2B+=M2w@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH v5 0/3] Add Phytec pbab01 audio support
From: Fabio Estevam <festevam@gmail.com>
To: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>,
        Shawn Guo <shawn.guo@linaro.org>
Cc: Shawn Guo <shawn.guo@freescale.com>, Sascha Hauer <kernel@pengutronix.de>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        perex@perex.cz, Takashi Iwai <tiwai@suse.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 11:47 AM, Dmitry Lavnikevich
<d.lavnikevich@sam-solutions.com> wrote:
> By mistake previous patchset versions was sent as in-reply-to to
> previous patchset versions, so they may have been lost among other
> mails.
>
> One of pathces was already applied by Mark Brown, here is 3 patches
> implementing audio support on Phytec phyFLEX-i.MX6 boards.
>
> This patchset version only renames audio card name to
> OnboardTLV320AIC3007 (on request from Phytec).
>
> Patches are based on branch for-next of
> git://git.kernel.org/pub/scm/linux/kernel/git/shawnguo/linux.git

Adding Shawn's email from Linaro.
