Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbbAORDO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 12:03:14 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:34452 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbbAORDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 12:03:12 -0500
MIME-Version: 1.0
In-Reply-To: <20150115162057.GC3043@sirena.org.uk>
References: <1421338359-27467-1-git-send-email-tomeu.vizoso@collabora.com>
 <1421338359-27467-11-git-send-email-tomeu.vizoso@collabora.com> <20150115162057.GC3043@sirena.org.uk>
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Date: Thu, 15 Jan 2015 18:02:51 +0100
X-Google-Sender-Auth: 2_ayFs0R5LWLh-O52Sy-JISzsqQ
Message-ID: <CAAObsKBKZsvLo9OjzcHiPEPq1iUeog0Bm-jzvxLrkt2X=N5djw@mail.gmail.com>
Subject: Re: [PATCH v2 10/11] ASoC: tegra: Add a control for the headphone switch
To: Mark Brown <broonie@kernel.org>
Cc: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Dylan Reid <dgreid@chromium.org>, Simon Glass <sjg@chromium.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Wolfram Sang <wsa@the-dreams.de>,
        alsa-devel@alsa-project.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 January 2015 at 17:20, Mark Brown <broonie@kernel.org> wrote:
> On Thu, Jan 15, 2015 at 05:12:22PM +0100, Tomeu Vizoso wrote:
>> To be used by userspace when the headphones jack is plugged in.
>
> I'm missing patches 1-9 of this series, what's going on there?

Sorry, no idea. They have reached lkml though:

https://lkml.org/lkml/2015/1/15/473

Regards,

Tomeu
