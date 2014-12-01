Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932626AbaLAWXO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 17:23:14 -0500
Received: from mail-qg0-f48.google.com ([209.85.192.48]:47656 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160AbaLAWXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 17:23:12 -0500
MIME-Version: 1.0
In-Reply-To: <20141201100100.GB20174@ulmo>
References: <1417173180-21726-1-git-send-email-vinceh@nvidia.com>
	<20141201100100.GB20174@ulmo>
Date: Tue, 2 Dec 2014 08:23:12 +1000
Message-ID: <CACAvsv72dwfT_7SBrXR1xOFFvW2_kM-CiwAfWQUhVNrwPPX-vA@mail.gmail.com>
Subject: Re: [Nouveau] [RESEND V2 PATCH 1/3] soc/tegra: fuse: export
 tegra_sku_info for module use
From: Ben Skeggs <skeggsb@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Vince Hsu <vinceh@nvidia.com>, Ben Skeggs <bskeggs@redhat.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 1, 2014 at 8:01 PM, Thierry Reding <thierry.reding@gmail.com> wrote:
> I think the subject doesn't need "for module use" because that's
> implicit in exporting a symbol.
>
> On Fri, Nov 28, 2014 at 07:12:58PM +0800, Vince Hsu wrote:
>> Some Tegra drivers might be complied as kernel modules, and
>
> "compiled"
>
>> they need the fuse information for initialization. One
>> example is the GK20A Nouveau driver. It needs the GPU speedo
>> value to calculate frequency-voltage table. So export
>> the tegra_sku_info.
>
> Also please wrap the commit message at around 72 characters. If you make
> the lines too short it becomes almost as difficult to readable as if
> they're too long.
>
> Other than these small nitpicks this looks like a reasonable change to
> me.
>
>>
>> Signed-off-by: Vince Hsu <vinceh@nvidia.com>
>> ---
>>
>> v2: add more description why we need this patch
>>
>>  drivers/soc/tegra/fuse/fuse-tegra.c | 1 +
>>  1 file changed, 1 insertion(+)
>
> Ben, patch 3/3 has a dependency on this one. Would you prefer to merge
> this as part of the Nouveau tree or do you want me to provide a stable
> branch that you can pull in to resolve the dependency?
I'll take the patch, seems the simplest option :)

Thanks,
Ben.

>
> In case of the former:
>
> Acked-by: Thierry Reding <treding@nvidia.com>
>
> _______________________________________________
> Nouveau mailing list
> Nouveau@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/nouveau
>
