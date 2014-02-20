Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464AbaBTEUv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 23:20:51 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:61029 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbaBTEUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 23:20:49 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20140220035431.GV2669@sirena.org.uk>
References: <1392736948-26623-1-git-send-email-ckeepax@opensource.wolfsonmicro.com> <1392736948-26623-2-git-send-email-ckeepax@opensource.wolfsonmicro.com> <20140220035431.GV2669@sirena.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH 01/17 v2] Input - arizona-haptics: Fix double lock of dapm_mutex
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date: Wed, 19 Feb 2014 20:20:39 -0800
To: Mark Brown <broonie@kernel.org>,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
CC: myungjoo.ham@samsung.com, cw00.choi@samsung.com, lgirdwood@gmail.com,
        lars@metafoo.de, peter.ujfalusi@ti.com, jarkko.nikula@bitmer.com,
        eric.y.miao@gmail.com, haojian.zhuang@gmail.com,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        alsa-devel@alsa-project.org, linux@arm.linux.org.uk
Message-ID: <b948e4a6-6c97-4734-9b86-babef0721311@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On February 19, 2014 7:54:31 PM PST, Mark Brown <broonie@kernel.org> wrote:
>On Tue, Feb 18, 2014 at 03:22:12PM +0000, Charles Keepax wrote:
>> snd_soc_dapm_sync takes the dapm_mutex internally, but we currently
>take
>> it externally as well. This patch fixes this.
>
>Dimitry, are you OK with this being merged via ASoC?  The subsequent
>improvements to the infrastructure and fix this more generally build on
>top of this one so they'll need to go together.


Sure, please go ahead.

Thanks.

-- 
Dmitry
