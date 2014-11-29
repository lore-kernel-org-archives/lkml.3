Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443AbaK2IWw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 03:22:52 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:51008 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbaK2IWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 03:22:51 -0500
MIME-Version: 1.0
In-Reply-To: <1417173180-21726-2-git-send-email-vinceh@nvidia.com>
References: <1417173180-21726-1-git-send-email-vinceh@nvidia.com> <1417173180-21726-2-git-send-email-vinceh@nvidia.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Sat, 29 Nov 2014 17:22:30 +0900
Message-ID: <CAAVeFuJp5pU62-=Bf=+i8nRX09vgZ4De00_f9kQjbp13jJa0+w@mail.gmail.com>
Subject: Re: [RESEND PATCH nouveau 2/3] volt: allow non-bios voltage scaling
To: Vince Hsu <vinceh@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Ben Skeggs <bskeggs@redhat.com>, Martin Peres <martin.peres@free.fr>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 8:12 PM, Vince Hsu <vinceh@nvidia.com> wrote:
> Signed-off-by: Vince Hsu <vinceh@nvidia.com>

Make sure you always write a short summary for your patches, even if
the title sounds sufficient.

At the very least this patch makes the code easier to read, so:

Acked-by: Alexandre Courbot <acourbot@nvidia.com>
