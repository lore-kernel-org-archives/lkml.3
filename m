Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbaKSRTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 12:19:34 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:62198 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754452AbaKSRTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 12:19:33 -0500
Message-ID: <546CD11F.6050502@free.fr>
Date: Wed, 19 Nov 2014 18:19:27 +0100
From: Mason <mpeg.blue@free.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:33.0) Gecko/20100101 Firefox/33.0 SeaMonkey/2.30
MIME-Version: 1.0
To: Victor Ascroft <victorascroft@gmail.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: Looking for good references for ARM driver development
References: <546C920A.7060800@free.fr> <546CCBF6.7070607@gmail.com>
In-Reply-To: <546CCBF6.7070607@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/11/2014 17:57, Victor Ascroft wrote:

> This actually depends on the kernel you are using. Do you have relatively
> new kernel or an old one? Depending on that, either you will get that
> information in a board file or else in the device tree in arch/arm/boot/dts.

I'll reply more thoroughly later, but I wanted to address this question.
We're targeting kernel 3.14.x

> This depends. If you have driver compiled in with the kernel this will happen
> on kernel boot up. If you have the driver as a loadable module, the probe hook
> will be called on modprobe or insmod.

Is this an answer to question 5?
I think there is some confusion with the "probe" terminology.

I meant "probe" as in "read the current value".
I think you mean "probe" as in "the driver probes for the device through
the probe method."

I meant to ask how often the hwmon framework "polls" the temperature sensor.

Regards.

