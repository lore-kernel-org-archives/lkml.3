Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbaKTNFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 08:05:20 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:61185 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbaKTNFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 08:05:19 -0500
MIME-Version: 1.0
X-Originating-IP: [95.23.100.213]
In-Reply-To: <201411201354.52679.arnd@arndb.de>
References: <1416254107-29326-1-git-send-email-soren.brinkmann@xilinx.com>
	<201411201354.52679.arnd@arndb.de>
Date: Thu, 20 Nov 2014 14:05:15 +0100
Message-ID: <CABxcv=mTMi=yOD_ZmO73P7V9skhuedf8yfxbPbQuoreJMRdCoQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: multi_v7_defconfig: Enable cgroups
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Olof Johansson <olof@lixom.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Nov 20, 2014 at 1:54 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 17 November 2014, Soren Brinkmann wrote:
>> This allows booting the kernel with systemd-based root file systems.
>>
>> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
>> ---
>> Hi,
>>
>> I don't know whether I'm the only one, but I use a initramfs with
>> systemd as init, which requires cgroup support in the kernel to fully
>> boot.
>>
>
> You probably are at this time, but I expect it to get more common
> in the future, I don't think enabling this is controversial at all.
>

Others are using it but with SoC specific defconfig and not multi_v7.

Newer version of systemd needs more config symbols to be enabled
besides cgroups, the full list is at
http://cgit.freedesktop.org/systemd/systemd/tree/README.

Tony recently added the recommended support to OMAP2+ defconfig so
something along these lines should be added to multi_v7 as a
follow-up:

673ce00c ("ARM: omap2plus_defconfig: Add support for distros with systemd")

Best regards,
Javier
