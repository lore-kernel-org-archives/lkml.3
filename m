Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575AbaLQXZl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 18:25:41 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:42878 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbaLQXZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 18:25:40 -0500
MIME-Version: 1.0
In-Reply-To: <1418786030-23455-1-git-send-email-computersforpeace@gmail.com>
References: <1418786030-23455-1-git-send-email-computersforpeace@gmail.com>
From: Gregory Fong <gregory.0xf0@gmail.com>
Date: Wed, 17 Dec 2014 15:25:09 -0800
Message-ID: <CADtm3G5ZaOsJ_pvY2ho0yYhbhbqtCwsPZfnEc0rwhCBC1ho16g@mail.gmail.com>
Subject: Re: [PATCH] ARM: brcmstb: update CPU power management sequence
To: Brian Norris <computersforpeace@gmail.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 7:13 PM, Brian Norris
<computersforpeace@gmail.com> wrote:
> The automatic CPU power state machine for B15 CPUs does not work
> reliably as-is. This patch implements a manual sequence in software to
> replace it.
>
> This was tested successfully with over 10,000 hotplug cycles of
> something like this:
>
>   echo 0 > /sys/devices/system/cpu/cpu1/online
>   echo 1 > /sys/devices/system/cpu/cpu1/online
>
> whereas the existing sequence often locks up after a few hundred cycles.
>
> Fixes: 62639c2f5332 ("ARM: brcmstb: reintroduce SMP support")
> Signed-off-by: Brian Norris <computersforpeace@gmail.com>

Acked-by: Gregory Fong <gregory.0xf0@gmail.com>
