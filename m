Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722AbaEBGZy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 02:25:54 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:17951 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbaEBGZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 02:25:52 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 01 May 2014 23:20:13 -0700
Message-ID: <53633A80.2040403@nvidia.com>
Date: Fri, 2 May 2014 09:26:08 +0300
From: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alexandre Courbot <gnurou@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC: Alex Courbot <acourbot@nvidia.com>, Ben Skeggs <bskeggs@redhat.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 04/10] drm/nouveau/fb: add GK20A support
References: <1398060142-7937-1-git-send-email-acourbot@nvidia.com>
 <1398060142-7937-5-git-send-email-acourbot@nvidia.com>
 <20140422104052.GB22426@ulmo> <53572077.6090305@nvidia.com>
 <CAAVeFuKscuN-=HJOarbzFkG1ARq6-Nfc2pf1ibam9b61Cjbs6Q@mail.gmail.com>
 <20140428114437.GK19455@ulmo>
 <CAAVeFuJrs8Sv9UZg=Tj6gJeHOXj9YSX4gT1TNdrfXvVfrBHerQ@mail.gmail.com>
In-Reply-To: <CAAVeFuJrs8Sv9UZg=Tj6gJeHOXj9YSX4gT1TNdrfXvVfrBHerQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.05.2014 07:49, Alexandre Courbot wrote:
> Agreed. Besides I hope the day won't come where we have to go through
> 2 layers of memory translation for the GPU...

That's actually the method of operation that gives us the best
performance. GPU likes big pages, and without IOMMU translation you'd
have a hard time finding enough contiguous physical memory.

Terje
