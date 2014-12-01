Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932858AbaLAXS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 18:18:26 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:46566 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932461AbaLAXSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 18:18:24 -0500
MIME-Version: 1.0
In-Reply-To: <547CF2F9.6040905@free.fr>
References: <1417173180-21726-1-git-send-email-vinceh@nvidia.com>
	<1417173180-21726-3-git-send-email-vinceh@nvidia.com>
	<547CF2F9.6040905@free.fr>
Date: Tue, 2 Dec 2014 09:18:24 +1000
Message-ID: <CACAvsv6dOhO46snBH_g+f2K1XvzPvqouF1ZBGF5GBbmoDaYnjQ@mail.gmail.com>
Subject: Re: [Nouveau] [RESEND PATCH nouveau 3/3] volt: add support for GK20A
From: Ben Skeggs <skeggsb@gmail.com>
To: Martin Peres <martin.peres@free.fr>
Cc: Vince Hsu <vinceh@nvidia.com>, Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 2, 2014 at 9:00 AM, Martin Peres <martin.peres@free.fr> wrote:
> On 28/11/2014 12:13, Vince Hsu wrote:
>>
>> The voltage value are calculated by the hardware characterized
>> result.
>>
>> Signed-off-by: Vince Hsu <vinceh@nvidia.com>
>> ---
>>
>> Resend this patch with the fuse change and proper patch prefix
>> per Thierry's request.
>
> Since the voltage table really is per-chipset, it would be insane
> to add that to the DT. If it was not the case, it is still easier to
> move to the DT instead of doing the opposite.
>
One thing that needs fixing is that this breaks the build on non-tegra arches.

> Acked-by: Martin Peres <martin.peres@free.fr>
>
> _______________________________________________
> Nouveau mailing list
> Nouveau@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/nouveau
