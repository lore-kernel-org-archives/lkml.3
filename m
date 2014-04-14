Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954AbaDNTv1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 15:51:27 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:40835 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbaDNTv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 15:51:26 -0400
MIME-Version: 1.0
In-Reply-To: <1396186455-3276-1-git-send-email-minipli@googlemail.com>
References: <1396186455-3276-1-git-send-email-minipli@googlemail.com>
Date: Mon, 14 Apr 2014 21:51:24 +0200
Message-ID: <CA+rthh_=fHedY0QN30jkDSNsQh3XfGyCqJMmUGaNyn5ZZp+qxw@mail.gmail.com>
Subject: Re: [PATCH 0/2] pda_power: USB notifier fixes
From: Mathias Krause <minipli@googlemail.com>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mathias Krause <minipli@googlemail.com>,
        PaX Team <pageexec@freemail.hu>, Felipe Balbi <balbi@ti.com>,
        Anton Vorontsov <anton@enomsg.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 March 2014 15:34, Mathias Krause <minipli@googlemail.com> wrote:
> The notifier block can and should be initialized statically. Fixed in
> patch 1.
>
> While doing patch 1 I noticed, that the USB notifier that gets registered
> in pda_power_probe() never gets unregistered. Fixed in patch 2.
>
> Beware: The patches are compile tested only, as I have no such hardware!
>
> Please apply!
>
> Mathias Krause (2):
>   pda_power: Statically initialize notifier block
>   pda_power: Unregister USB notifier in pda_power_remove()
>
>  drivers/power/pda_power.c |   11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>
> --

Ping? Any opinions on this series? Dmitry, David?
