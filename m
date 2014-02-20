Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbaBTEMj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 23:12:39 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:52781 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbaBTEMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 23:12:38 -0500
MIME-Version: 1.0
In-Reply-To: <20140210123757.GF20143@ulmo.nvidia.com>
References: <1391938998-4848-1-git-send-email-acourbot@nvidia.com> <20140210123757.GF20143@ulmo.nvidia.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 20 Feb 2014 13:12:17 +0900
Message-ID: <CAAVeFuL-RyRew=dni=Rd_RzPNbhjckryznm2xtp1r4yho_+Z7w@mail.gmail.com>
Subject: Re: [PATCH] drm/ttm: declare 'struct device' in ttm_page_alloc.h
To: David Airlie <airlied@linux.ie>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping, David?

On Mon, Feb 10, 2014 at 9:37 PM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> On Sun, Feb 09, 2014 at 06:43:18PM +0900, Alexandre Courbot wrote:
>> Declare 'struct device' explicitly in ttm_page_alloc.h as this file
>> does not include any file declaring it. This removes the following
>> warning:
>>
>>       warning: 'struct device' declared inside parameter list
>>
>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>> ---
>> This warning was visible when compiling Nouveau on -next today.
>>
>>  include/drm/ttm/ttm_page_alloc.h | 2 ++
>>  1 file changed, 2 insertions(+)
>
> I don't think I've seen this on x86, but I've certainly encountered the
> same warning when building nouveau on ARM, so:
>
> Reviewed-by: Thierry Reding <treding@nvidia.com>
