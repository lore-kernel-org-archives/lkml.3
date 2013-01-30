Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab3A3Hav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 02:30:51 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3186 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491Ab3A3Hau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 02:30:50 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 29 Jan 2013 23:30:49 -0800
Message-ID: <5108CC25.7080709@nvidia.com>
Date: Wed, 30 Jan 2013 16:30:45 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130109 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Mark Zhang <nvmarkzhang@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Mark Zhang <markz@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "gnurou@gmail.com" <gnurou@gmail.com>
Subject: Re: [RFC 3/4] drm: tegra: use the Common Display Framework
References: <1359514939-15653-1-git-send-email-acourbot@nvidia.com> <1359514939-15653-4-git-send-email-acourbot@nvidia.com> <5108C298.1000500@gmail.com> <5108C55C.30104@nvidia.com> <20130130072406.GA17128@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20130130072406.GA17128@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2013 04:24 PM, Thierry Reding wrote:
>>> Could you pick up a somewhat meaningful name? You know, there are too
>>> many variables with name "drm/connector/output/encoder"... :)
>>
>> Well, it's supposed to be abstract. From the CDF point of view it
>> could be anything besides a panel. I know this makes it an output of
>> an output, but I can't think of anything better right now.
>
> How about renaming "this" to stream to match with what the output is in
> CDF speak.

Good idea.

> And the output's output is the panel, right? Why not just
> call it that? Even if it isn't directly connected to a panel entity but
> has indeed a whole pipeline in between, for tegra-drm it is still a
> panel.

Makes sense indeed. Besides the DT refer it as "panel" already.

Thanks,
Alex.
