Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932733AbaLAXAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 18:00:22 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:56040 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932458AbaLAXAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 18:00:20 -0500
Message-ID: <547CF2F9.6040905@free.fr>
Date: Tue, 02 Dec 2014 00:00:09 +0100
From: Martin Peres <martin.peres@free.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Vince Hsu <vinceh@nvidia.com>, swarren@wwwdotorg.org,
        thierry.reding@gmail.com, gnurou@gmail.com, pdeschrijver@nvidia.com,
        bskeggs@redhat.com
CC: nouveau@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH nouveau 3/3] volt: add support for GK20A
References: <1417173180-21726-1-git-send-email-vinceh@nvidia.com> <1417173180-21726-3-git-send-email-vinceh@nvidia.com>
In-Reply-To: <1417173180-21726-3-git-send-email-vinceh@nvidia.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/11/2014 12:13, Vince Hsu wrote:
> The voltage value are calculated by the hardware characterized
> result.
>
> Signed-off-by: Vince Hsu <vinceh@nvidia.com>
> ---
>
> Resend this patch with the fuse change and proper patch prefix
> per Thierry's request.
Since the voltage table really is per-chipset, it would be insane
to add that to the DT. If it was not the case, it is still easier to
move to the DT instead of doing the opposite.

Acked-by: Martin Peres <martin.peres@free.fr>
