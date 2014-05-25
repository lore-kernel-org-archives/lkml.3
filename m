Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546AbaEYMwY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 08:52:24 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:37728 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbaEYMwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 08:52:23 -0400
Message-ID: <5381E867.2010009@gmail.com>
Date: Sun, 25 May 2014 08:56:07 -0400
From: Woody Suwalski <terraluna977@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:29.0) Gecko/20100101 Firefox/29.0 SeaMonkey/2.26
MIME-Version: 1.0
To: =?UTF-8?B?TWFsdGUgU2NocsO2ZGVy?= <maltesch@gmx.de>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: Radeon wakeup regression in 3.15-rc6
References: <53805C4E.7050205@gmx.de>
In-Reply-To: <53805C4E.7050205@gmx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Malte Schröder wrote:
> Hi,
> I just tried 3.15-rc6. I encountered a pretty nasty problem, which is
> after suspending to RAM the system doesn't wake up properly. v3.14 is fine.
> On wakeup all seems fine, i.e. hd starts to spin an USB-stuff wakes up.
> But all I get from the graphics card is a white screen slowly filling
> with random colored pixels. I had to hard reset the system.
>
> I attached the kernel log, the X-servers log, lspci-output and my kernel
> config.
>
> Regards
> Malte
I have seen a bit of a screen distortion at the bottom of LCD on Radeon 
after a wakeup.
I tried to re-run with drm.debug=0x0e, however once I did it - the 
problem has disappeared, and I have not been able to duplicate it again. 
So just watching for now.
OTOH I have seen (only one time) a black screen after wakeup on Nvidia. 
So maybe some timing is now exposed in PM / DRM...

Woody


