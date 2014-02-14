Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937AbaBNCCX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 21:02:23 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:32852 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbaBNCCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 21:02:21 -0500
MIME-Version: 1.0
In-Reply-To: <20140210121431.GD20143@ulmo.nvidia.com>
References: <1392011821-2406-1-git-send-email-acourbot@nvidia.com>
	<20140210121431.GD20143@ulmo.nvidia.com>
Date: Fri, 14 Feb 2014 12:02:20 +1000
Message-ID: <CACAvsv6LoNinrLviqFDqsngSokuq2eJj7-8Hq-vapO5rSkCCpw@mail.gmail.com>
Subject: Re: [Nouveau] [PATCH] drm/nouveau/fifo: allocate usermem as needed
From: Ben Skeggs <skeggsb@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 10:14 PM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> On Mon, Feb 10, 2014 at 02:57:01PM +0900, Alexandre Courbot wrote:
>> Memory was always allocated for 4096 channels. Change this to allocate
>> what we actually need according to the number of channels we use.
>>
>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>> ---
>>  drivers/gpu/drm/nouveau/core/engine/fifo/nve0.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> Looks good to me:
>
> Reviewed-by: Thierry Reding <treding@nvidia.com>
Thanks guys!

>
> _______________________________________________
> Nouveau mailing list
> Nouveau@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/nouveau
>
