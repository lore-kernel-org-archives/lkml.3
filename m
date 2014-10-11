Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbaJKQVe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 12:21:34 -0400
Received: from smtp-out-029.synserver.de ([212.40.185.29]:1034 "EHLO
	smtp-out-029.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbaJKQVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 12:21:33 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 27692
Message-ID: <5439591B.4020701@metafoo.de>
Date: Sat, 11 Oct 2014 18:21:47 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: dmaengine@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/12] ASoC: txx9: use dmaengine_terminate_all() API
References: <1413041973-28146-1-git-send-email-vinod.koul@intel.com> <1413042040-28222-11-git-send-email-vinod.koul@intel.com>
In-Reply-To: <1413042040-28222-11-git-send-email-vinod.koul@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2014 05:40 PM, Vinod Koul wrote:
> The drivers should use dmaengine_terminate_all() API instead of
> accessing the device_control which will be deprecated soon

I already send a similar patch a while ago. It is on it's way into 3.18.

>
> Signed-off-by: Vinod Koul <vinod.koul@intel.com>
