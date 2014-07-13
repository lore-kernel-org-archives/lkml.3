Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279AbaGMChl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 22:37:41 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:38737 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbaGMChg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 22:37:36 -0400
MIME-Version: 1.0
In-Reply-To: <20140711131421.GD10827@ulmo>
References: <1404822734-8603-1-git-send-email-acourbot@nvidia.com>
 <1404822734-8603-5-git-send-email-acourbot@nvidia.com> <20140711131421.GD10827@ulmo>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Sun, 13 Jul 2014 11:37:14 +0900
Message-ID: <CAAVeFuKMU3vpDoog-k3X82OZn1VR5iRMpwo5LSeX7cPMOqfXVg@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] ARM: tegra: roth: add display DT node
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Terje Bergstrom <tbergstrom@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 10:14 PM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> On Tue, Jul 08, 2014 at 09:32:14PM +0900, Alexandre Courbot wrote:
>> Tegra DSI support has been fixed to support continuous clock behavior that
>> the panel used on SHIELD requires, so finally add its device tree node
>> since it is functional.
>>
>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>> ---
>>  arch/arm/boot/dts/tegra114-roth.dts | 22 +++++++++++++++++++---
>>  1 file changed, 19 insertions(+), 3 deletions(-)
>
> I've applied this to Tegra's for-3.17/dt branch. Thanks.

Thanks - how about the other patches of the series? Ideally this one
should be applied last.
