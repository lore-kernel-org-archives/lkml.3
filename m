Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab3JHF0s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 01:26:48 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:19420 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab3JHF0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 01:26:46 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 07 Oct 2013 22:22:39 -0700
Message-ID: <525396AB.4010804@nvidia.com>
Date: Tue, 8 Oct 2013 08:22:51 +0300
From: Arto Merilainen <amerilainen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Erik Faye-Lund <kusmabite@gmail.com>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Terje Bergstrom <tbergstrom@nvidia.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpu: host1x: check relocs after all gathers are consumed
References: <1380917913-20482-1-git-send-email-kusmabite@gmail.com>
In-Reply-To: <1380917913-20482-1-git-send-email-kusmabite@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2013 11:18 PM, Erik Faye-Lund wrote:
> The num_relocs count are passed to the kernel per job, not per gather.
>
> For multi-gather jobs, we would previously fail if there were relocs in
> other gathers aside from the first one.
>
> Fix this by simply moving the check until all gathers have been
> consumed.
>
> Signed-off-by: Erik Faye-Lund <kusmabite@gmail.com>

Reviewed-by: Arto Merilainen <amerilainen@nvidia.com>

- Arto
