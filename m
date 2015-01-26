Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922AbbAZWKu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 17:10:50 -0500
Received: from smtp-out-161.synserver.de ([212.40.185.161]:1048 "EHLO
	smtp-out-161.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbbAZWKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 17:10:47 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 13614
Message-ID: <54C6BB63.60809@metafoo.de>
Date: Mon, 26 Jan 2015 23:10:43 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.4.0
MIME-Version: 1.0
To: Peter Rosin <peda@lysator.liu.se>, alsa-devel@alsa-project.org
CC: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@linaro.org>, Peter Rosin <peda@axentia.se>
Subject: Re: [alsa-devel] [PATCH 1/7] ALSA: pcm: Add snd_interval_ranges()
 and snd_pcm_hw_constraint_ranges()
References: <1421236370-19826-1-git-send-email-peda@lysator.liu.se> <1421236370-19826-2-git-send-email-peda@lysator.liu.se>
In-Reply-To: <1421236370-19826-2-git-send-email-peda@lysator.liu.se>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2015 12:52 PM, Peter Rosin wrote:
> From: Peter Rosin <peda@axentia.se>
>
> Add helper functions to allow drivers to specify several disjoint
> ranges for a variable. In particular, there is a codec (PCM512x) that
> has a hole in its supported range of rates, due to PLL and divider
> restrictions.

Might be worth mentioning that this is the extension of 
snd_pcm_hw_constraint_list() from points to ranges. Otherwise looks good.

Reviewed-by: Lars-Peter Clausen <lars@metafoo.de>

