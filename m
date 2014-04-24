Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427AbaDXGnw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 02:43:52 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:56155 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaDXGnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 02:43:50 -0400
MIME-Version: 1.0
In-Reply-To: <20140423005043.GF5738@verge.net.au>
References: <1398171667-24288-1-git-send-email-geert+renesas@glider.be>
	<1398171667-24288-2-git-send-email-geert+renesas@glider.be>
	<20140423005043.GF5738@verge.net.au>
Date: Thu, 24 Apr 2014 15:43:49 +0900
Message-ID: <CANqRtoRuZrTa-OGt7sB=MLTYyVstgHVsFESg6C=LrL482seaSg@mail.gmail.com>
Subject: Re: [PATCH RFC 2/2] ARM: shmobile: armadillo800eva defconfig: Enable
 REGULATOR_GPIO and LEDS_GPIO
From: Magnus Damm <magnus.damm@gmail.com>
To: Simon Horman <horms@verge.net.au>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        SH-Linux <linux-sh@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 9:50 AM, Simon Horman <horms@verge.net.au> wrote:
> On Tue, Apr 22, 2014 at 03:01:07PM +0200, Geert Uytterhoeven wrote:
>> Refresh armadillo800eva_defconfig, and enable missing options for devices
>> in platform data and/or DT:
>>   - REGULATOR_GPIO
>>   - LEDS_GPIO
>
> I would prefer if changes were made in a more incremental patch.
>
> * A patch to enable LEDS_GPIO and REGULATOR_GPIO.
> * Then a cleanup patch, if you really want to do that: but why?
>
>>
>> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>> ---
>> Do we want SHMOBILE_IOMMU, too? The help text says "If unsure, say N."
>> If yes, is the default SHMOBILE_IOMMU_ADDRSIZE_2048MB OK?
>
> I defer to Magnus on that one.

I think it's best to go with a "N" here. Unless someone can prove to
me that we need it and that it is working!

In general I'd like to begin by integrating IOMMU support for R-Car
Gen2 in a controlled manner and once that is in place I think we can
revisit this older case. At that time hopefully we will be dealing
with the multiplatform defconfig for r8a7740 and Armadillo.

Cheers,

/ magnus
