Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050AbaGKBmc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 21:42:32 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:4568 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbaGKBma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 21:42:30 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 10 Jul 2014 18:35:24 -0700
Message-ID: <53BF4102.6010807@nvidia.com>
Date: Fri, 11 Jul 2014 10:42:26 +0900
From: Alexandre Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Mikko Perttunen <mperttunen@nvidia.com>, Ben Skeggs <bskeggs@redhat.com>,
        Ken Adams <KAdams@nvidia.com>
CC: "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gnurou@gmail.com" <gnurou@gmail.com>
Subject: Re: [PATCH 0/3] drm/gk20a: support for reclocking
References: <1404977677-22248-1-git-send-email-acourbot@nvidia.com> <53BE61D9.4020202@nvidia.com>
In-Reply-To: <53BE61D9.4020202@nvidia.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2014 06:50 PM, Mikko Perttunen wrote:
> Does GK20A itself have any kind of thermal protection capabilities?
> Upstream SOCTHERM support is not yet available (though I have a driver
> in my tree), so we are thinking of disabling CPU DVFS on boards that
> don't have always-on active cooling for now. Same might be necessary for
> GPU as well.

There is a small thermal driver ( 
https://android.googlesource.com/kernel/tegra/+/b445e5296764d18861a6450f6851f25b9ca59dee/drivers/video/tegra/host/gk20a/therm_gk20a.c 
) but it doesn't seem to do much. I believe that for Tegra we rely in 
SOCTHERM instead, but maybe Ken could confirm?
