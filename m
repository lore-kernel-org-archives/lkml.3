Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004AbaG3MZo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:25:44 -0400
Received: from muin.pair.com ([209.68.1.55]:52691 "EHLO muin.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753098AbaG3MZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:25:42 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Jul 2014 08:25:42 EDT
Message-ID: <53D8E2B4.6060009@tabi.org>
Date: Wed, 30 Jul 2014 07:19:00 -0500
From: Timur Tabi <timur@tabi.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:29.0) Gecko/20100101 Firefox/29.0 SeaMonkey/2.26.1
MIME-Version: 1.0
To: Nicolin Chen <nicoleotsuka@gmail.com>, broonie@kernel.org
CC: alsa-devel@alsa-project.org, lgirdwood@gmail.com, tiwai@suse.de,
        perex@perex.cz, linux-kernel@vger.kernel.org, Li.Xiubo@freescale.com,
        linuxppc-dev@lists.ozlabs.org, b42378@freescale.com,
        b02247@freescale.com
Subject: Re: [PATCH 4/4] ASoC: fsl_ssi: Add stream names for DPCM usage
References: <cover.1406688048.git.nicoleotsuka@gmail.com> <891b9f4edbba81a03c2b8350abc5ccf923db9260.1406688049.git.nicoleotsuka@gmail.com>
In-Reply-To: <891b9f4edbba81a03c2b8350abc5ccf923db9260.1406688049.git.nicoleotsuka@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolin Chen wrote:
> DPCM needs extra dapm routes in the machine driver to route audio
> between Front-End and Back-End. In order to differ the stream names
> in the route map from CODECs, we here add specific stream names to
> SSI driver so that we can implement ASRC via DPCM to it.
>
> Signed-off-by: Nicolin Chen<nicoleotsuka@gmail.com>

Acked-by: Timur Tabi <timur@tabi.org>
