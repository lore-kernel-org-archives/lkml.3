Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbaFXKdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 06:33:17 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:12570 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbaFXKdQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 06:33:16 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 24 Jun 2014 03:23:29 -0700
Message-ID: <53A953E6.2030503@nvidia.com>
Date: Tue, 24 Jun 2014 19:33:10 +0900
From: Alexandre Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        Lucas Stach <dev@lynxeye.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        "gnurou@gmail.com" <gnurou@gmail.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 2/3] drm/ttm: introduce dma cache sync helpers
References: <1403603667-11302-1-git-send-email-acourbot@nvidia.com> <1403603667-11302-3-git-send-email-acourbot@nvidia.com> <20140624100220.GK32514@n2100.arm.linux.org.uk>
In-Reply-To: <20140624100220.GK32514@n2100.arm.linux.org.uk>
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2014 07:02 PM, Russell King - ARM Linux wrote:
> On Tue, Jun 24, 2014 at 06:54:26PM +0900, Alexandre Courbot wrote:
>> From: Lucas Stach <dev@lynxeye.de>
>>
>> On architectures for which access to GPU memory is non-coherent,
>> caches need to be flushed and invalidated explicitly at the
>> appropriate places. Introduce two small helpers to make things
>> easy for TTM-based drivers.
>
> Have you run this with DMA API debugging enabled?  I suspect you haven't,
> and I recommend that you do.

# cat /sys/kernel/debug/dma-api/error_count
162621

(╯°□°）╯︵ ┻━┻)

