Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab3KTJQs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 04:16:48 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:37795 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab3KTJQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 04:16:41 -0500
Date: Wed, 20 Nov 2013 09:16:36 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: broonie@kernel.org, lgirdwood@gmail.com, sameo@linux.intel.com,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] ASoC: wm5110: Expose input high pass filter controls
Message-ID: <20131120091636.GA30012@lee--X1>
References: <1384877043-5640-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1384877043-5640-5-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1384877043-5640-5-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Nov 2013, Charles Keepax wrote:

> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm5110-tables.c           |    4 +++
>  include/linux/mfd/arizona/registers.h |   37 +++++++++++++++++++++++++++++++++
>  sound/soc/codecs/arizona.c            |   10 +++++++++
>  sound/soc/codecs/arizona.h            |    1 +
>  sound/soc/codecs/wm5110.c             |   19 +++++++++++++++++
>  5 files changed, 71 insertions(+), 0 deletions(-)

For the MFD parts: Acked-by: Lee Jones <lee.jones@linaro.org>

How do you want to play this ASoC?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
