Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932711AbaLAW55 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 17:57:57 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:51497 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932458AbaLAW54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 17:57:56 -0500
Message-ID: <547CF263.6070900@free.fr>
Date: Mon, 01 Dec 2014 23:57:39 +0100
From: Martin Peres <martin.peres@free.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Alexandre Courbot <gnurou@gmail.com>, Vince Hsu <vinceh@nvidia.com>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH nouveau 2/3] volt: allow non-bios voltage scaling
References: <1417173180-21726-1-git-send-email-vinceh@nvidia.com> <1417173180-21726-2-git-send-email-vinceh@nvidia.com> <CAAVeFuJp5pU62-=Bf=+i8nRX09vgZ4De00_f9kQjbp13jJa0+w@mail.gmail.com>
In-Reply-To: <CAAVeFuJp5pU62-=Bf=+i8nRX09vgZ4De00_f9kQjbp13jJa0+w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/11/2014 09:22, Alexandre Courbot wrote:
> On Fri, Nov 28, 2014 at 8:12 PM, Vince Hsu <vinceh@nvidia.com> wrote:
>> Signed-off-by: Vince Hsu <vinceh@nvidia.com>
> Make sure you always write a short summary for your patches, even if
> the title sounds sufficient.

I agree. Something like "Move the vbios parsing out of init() and
call it conditionally if the platform has a vbios. Non-vbios platforms
can use the ctor() to init the data structures.".

> At the very least this patch makes the code easier to read, so:
>
> Acked-by: Alexandre Courbot <acourbot@nvidia.com>
Acked-by: Martin Peres <martin.peres@free.fr>
