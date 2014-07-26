Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751031AbaGZHxh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 03:53:37 -0400
Received: from mail-oi0-f47.google.com ([209.85.218.47]:46865 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbaGZHxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 03:53:36 -0400
MIME-Version: 1.0
In-Reply-To: <20140725172126.GA24306@sirena.org.uk>
References: <1406203117-2767-1-git-send-email-kiran.padwal21@gmail.com>
	<20140725172126.GA24306@sirena.org.uk>
Date: Sat, 26 Jul 2014 13:23:35 +0530
Message-ID: <CA+neC=Pj2_L9yBiE2yp0UhL6wodLmJAeri4vc_UTCi=sEw2nLA@mail.gmail.com>
Subject: Re: [PATCH] ASoC: ak4642: Make of_device_id array const
From: kiran padwal <kiran.padwal21@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, perex@perex.cz, tiwai@suse.de,
        s.hauer@pengutronix.de, fabio.estevam@freescale.com,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Li.Xiubo@freescale.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 10:51 PM, Mark Brown <broonie@kernel.org> wrote:
> On Thu, Jul 24, 2014 at 05:28:36PM +0530, Kiran Padwal wrote:
>> Make of_device_id array const, because all OF functions handle it as const
>
> ...and reverted because it fails to build.

sorry for that...I miss one thing...I will resubmit the patch.
Thanks.
