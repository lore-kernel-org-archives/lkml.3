Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab3LKTPX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 14:15:23 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:2648 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab3LKTPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 14:15:18 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 11 Dec 2013 11:16:59 -0800
Date: Wed, 11 Dec 2013 11:15:16 -0800
From: Paul Walmsley <pwalmsley@nvidia.com>
X-X-Sender: pwalmsley@tamien
To: Thierry Reding <thierry.reding@gmail.com>
CC: Mikko Perttunen <mperttunen@nvidia.com>,
        Arto Merilainen <amerilainen@nvidia.com>,
        Terje Bergstrom <tbergstrom@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH] gpu: host1x: clk_round_rate() can return a zero upon
 error
In-Reply-To: <20131211151908.GC31617@ulmo.nvidia.com>
Message-ID: <alpine.DEB.2.02.1312111113050.1653@tamien>
References: <alpine.DEB.2.02.1312091746400.4127@tamien> <20131211151908.GC31617@ulmo.nvidia.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 11 Dec 2013, Thierry Reding wrote:

> Perhaps unsigned long long would be a better choice for future
> compatibility?

Yes - at this point am planning to go straight to u64.

- Paul
