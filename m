Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577Ab3BKPk0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 10:40:26 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1623 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757255Ab3BKPkY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 10:40:24 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 11 Feb 2013 07:39:45 -0800
Message-ID: <511910DA.8070600@nvidia.com>
Date: Mon, 11 Feb 2013 07:40:10 -0800
From: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Arto Merilainen <amerilainen@nvidia.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv5,RESEND 8/8] drm: tegra: Add gr2d device
References: <1358250244-9678-1-git-send-email-tbergstrom@nvidia.com> <1358250244-9678-9-git-send-email-tbergstrom@nvidia.com> <20130204125618.GD595@avionic-0098.mockup.avionic-design.de> <511095F9.6040607@nvidia.com> <20130205095403.GF20437@avionic-0098.mockup.avionic-design.de> <5112C9C5.8080205@nvidia.com> <20130208070734.GB15429@avionic-0098.mockup.avionic-design.de> <51183E8D.1090607@nvidia.com> <20130211064452.GA16676@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20130211064452.GA16676@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.02.2013 22:44, Thierry Reding wrote:
> On Sun, Feb 10, 2013 at 04:42:53PM -0800, Terje Bergström wrote:
>> You're right about performance. We already saw quite a bad performance
>> hit with the current firewall, so we'll need to worry about performance
>> later.
> 
> I guess the additional overhead of looking up in a table vs. an actual
> function being run will be rather small compared to the total overhead
> incurred by having the firewall in the first place.

Yeah, I'll just implement a simple linear table lookup and let's see
what happens. I'll optimize with bitfield if needed.

Terje
