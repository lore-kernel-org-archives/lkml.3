Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539AbbAFN3E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 08:29:04 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45215 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753079AbbAFN3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 08:29:01 -0500
Date: Tue, 6 Jan 2015 13:28:58 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Zidan Wang <b50113@freescale.com>
Cc: broonie@kernel.org, lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        lars@metafoo.de, Li.Xiubo@freescale.com,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel][PATCH 4/4] ASoC: wm8960: Fix capture sample rate
	from 11250 to 11025
Message-ID: <20150106132858.GP14516@opensource.wolfsonmicro.com>
References: <1419997154-860-1-git-send-email-b50113@freescale.com> <1419997154-860-4-git-send-email-b50113@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419997154-860-4-git-send-email-b50113@freescale.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2014 at 11:39:14AM +0800, Zidan Wang wrote:
> wm8960 codec can't support sample rate 11250, it must be 11025.
> 
> Signed-off-by: Zidan Wang <b50113@freescale.com>
> ---

Acked-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

Thanks,
Charles
