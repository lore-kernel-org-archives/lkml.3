Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748Ab3BOWTD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 17:19:03 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:41295 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab3BOWTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 17:19:01 -0500
MIME-Version: 1.0
In-Reply-To: <1360965237-14857-1-git-send-email-swarren@wwwdotorg.org>
References: <1360965237-14857-1-git-send-email-swarren@wwwdotorg.org>
Date: Fri, 15 Feb 2013 14:18:59 -0800
X-Google-Sender-Auth: FqIij5eUQnvEkQkDBogiVal_2eM
Message-ID: <CAA9_cme3e-VWFs+5o6g88dXmURsjojT08o9Cw+=r7=AfRKz5gQ@mail.gmail.com>
Subject: Re: [PATCH] dma: tegra: assume CONFIG_OF
From: Dan Williams <djbw@fb.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        "Koul, Vinod" <vinod.koul@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 1:53 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> From: Stephen Warren <swarren@nvidia.com>
>
> Tegra only supports, and always enables, device tree. Remove all ifdefs
> and runtime checks for DT support from the driver.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Acked-by: Dan Williams <djbw@fb.com>

..adding Vinod.
