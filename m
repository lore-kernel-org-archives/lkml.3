Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815AbaESUgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 16:36:24 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:60670 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbaESUgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 16:36:23 -0400
MIME-Version: 1.0
In-Reply-To: <CAC5F_1mrXgEtx7sx1ihdm5EA6cxP7cA7mOjVmP8HvWxatgAcRA@mail.gmail.com>
References: <1400520254-5142-1-git-send-email-spang@chromium.org>
	<1400521493.5367.61.camel@edumazet-glaptop2.roam.corp.google.com>
	<CAC5F_1mrXgEtx7sx1ihdm5EA6cxP7cA7mOjVmP8HvWxatgAcRA@mail.gmail.com>
Date: Mon, 19 May 2014 13:36:21 -0700
Message-ID: <CAHA+R7PKPRkC5hvsS=M3muo4pzH8XrvP2c7=qR1Yo_dS5Yh-yA@mail.gmail.com>
Subject: Re: [PATCH] macvlan: Fix checksum errors when ip_summed is CHECKSUM_PARTIAL
From: Cong Wang <cwang@twopensource.com>
To: Michael Spang <spang@chromium.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Patrick McHardy <kaber@trash.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@free.fr>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 1:05 PM, Michael Spang <spang@chromium.org> wrote:
> On Mon, May 19, 2014 at 1:44 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>
>> I removed stable@ , as stable submissions are not done like that.
>>
>
> Perhaps I've misunderstood something, but this suggestion is right
> from https://www.kernel.org/doc/Documentation/stable_kernel_rules.txt
>
>  - To have the patch automatically included in the stable tree, add the tag
>      Cc: stable@vger.kernel.org
>    in the sign-off area. Once the patch is merged it will be applied to
>    the stable tree without anything else needing to be done by the author
>    or subsystem maintainer.

netdev has different rules, you need to check
Documentation/networking/netdev-FAQ.txt.
