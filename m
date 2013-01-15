Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599Ab3AOLfr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 06:35:47 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6093 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756342Ab3AOLfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 06:35:46 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 15 Jan 2013 03:35:35 -0800
Message-ID: <50F5404F.50904@nvidia.com>
Date: Tue, 15 Jan 2013 13:41:03 +0200
From: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Arto Merilainen <amerilainen@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v2 6/8] gpu: drm: tegra: Remove redundant host1x
References: <50CAC2AC.1010704@nvidia.com> <50CB5205.1030303@wwwdotorg.org> <50CB850F.9090704@nvidia.com> <20121216121603.GA31780@avionic-0098.adnet.avionic-design.de> <50D2D792.1050401@nvidia.com> <50D34775.5010606@wwwdotorg.org> <50D42486.7080901@nvidia.com> <50D4D25B.7030506@wwwdotorg.org> <50E6AA69.4030001@nvidia.com> <50E73AA2.7090500@wwwdotorg.org> <20130115113049.GB18119@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20130115113049.GB18119@avionic-0098.adnet.avionic-design.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.01.2013 13:30, Thierry Reding wrote:
> Sorry for not getting back to you on this earlier. I just remembered
> this thread when I saw Terje's latest patch series.
> 
> I agree that having everything in one location will make things a lot
> easier, even if it means we have to add the tegra-drm driver to a new
> location. In the long run I think this will pay off, though.
> 
> That said, I see that Terje has chosen this approach in his latest
> series, so it's all good.

*whew* Thanks Thierry. I'm not entirely sure that drivers/gpu/host1x is
the correct location, though - host1x looks pretty lonely there. If
anybody has a strong opinion about the location, I'm willing to adjust.

Terje
