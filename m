Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858AbaEPKDv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 06:03:51 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:51247 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258AbaEPKDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 06:03:49 -0400
MIME-Version: 1.0
In-Reply-To: <1400230809-11401-1-git-send-email-chander.kashyap@linaro.org>
References: <1400230809-11401-1-git-send-email-chander.kashyap@linaro.org>
Date: Fri, 16 May 2014 15:33:49 +0530
Message-ID: <CAKohpokzz0xOnseM=wdyQ0_xf1G2d6=1vTvh+ztVRg-Vr0PxZw@mail.gmail.com>
Subject: Re: [PATCH v3] PM / OPP: discard duplicate OPPs
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Chander Kashyap <chander.kashyap@linaro.org>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>, "Brown, Len" <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chander Kashyap <k.chander@samsung.com>,
        Inderpal Singh <inderpal.s@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 May 2014 14:30, Chander Kashyap <chander.kashyap@linaro.org> wrote:
> From: Chander Kashyap <k.chander@samsung.com>
>
> This patch detects the duplicate OPP entries and discards them

I wish this would have been a bit more explanatory :)

> Signed-off-by: Chander Kashyap <k.chander@samsung.com>
> Signed-off-by: Inderpal Singh <inderpal.s@samsung.com>
> ---
>  Changes in v3:
>         - Modify the commit log
>  Changes in v2:
>         - Reorder check for duplicate opp
>
>  drivers/base/power/opp.c |   13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
