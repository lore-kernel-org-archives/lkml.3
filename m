Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192AbaE2KQf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 06:16:35 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:61924 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757166AbaE2KQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 06:16:33 -0400
MIME-Version: 1.0
In-Reply-To: <1400482268-4971-1-git-send-email-acourbot@nvidia.com>
References: <1400482268-4971-1-git-send-email-acourbot@nvidia.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 29 May 2014 19:16:11 +0900
Message-ID: <CAAVeFuLHjwjQPB+O3WExKjDQ+ZxFzxi_P3Pr1WuqwK5ApcFJ3w@mail.gmail.com>
Subject: Re: [PATCH 0/2] drm/gk20a: FB fixes
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Ben Skeggs <bskeggs@redhat.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben, I am withdrawing this series as it will be superseeded by a new
version. You probably did not intend to merge it, but just in case. :)

On Mon, May 19, 2014 at 3:51 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> Fix a very shameful memory leak and a compilation error due to the use of
> non-exported CMA functions. The workaround for the latter is not really elegant
> (replace the CMA functions by a runtime failure if we are compiled as a
> module), but is temporary and still an improvement over the current situation
> (compile error).
>
> Alexandre Courbot (2):
>   drm/gk20a/fb: fix huge memory leak
>   drm/gk20a/fb: fix compile error whith CMA and module
>
>  drivers/gpu/drm/nouveau/core/subdev/fb/ramgk20a.c | 95 ++++++++++++++++-------
>  1 file changed, 67 insertions(+), 28 deletions(-)
>
> --
> 1.9.2
>
