Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627AbaEKXYI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 19:24:08 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:49694 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbaEKXYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 19:24:05 -0400
MIME-Version: 1.0
In-Reply-To: <20140511004626.GW31760@verge.net.au>
References: <1399411579-10681-1-git-send-email-geert+renesas@glider.be>
	<CAMuHMdWwenyU1RS4c8spFcb7M0oCXP9z8zbGQ0VACKj7EbvvkA@mail.gmail.com>
	<20140511004626.GW31760@verge.net.au>
Date: Mon, 12 May 2014 08:24:03 +0900
Message-ID: <CANqRtoQzxdjwU+BLyccrSzfBx3UMKm6=MAw9dUHSEBWm5_Vspg@mail.gmail.com>
Subject: Re: [PATCH v4] drivers: sh: compile drivers/sh/pm_runtime.c if ARCH_SHMOBILE_MULTI
From: Magnus Damm <magnus.damm@gmail.com>
To: Simon Horman <horms@verge.net.au>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2014 at 9:46 AM, Simon Horman <horms@verge.net.au> wrote:
> On Thu, May 08, 2014 at 12:12:29PM +0200, Geert Uytterhoeven wrote:
>> On Tue, May 6, 2014 at 11:26 PM, Geert Uytterhoeven
>> <geert+renesas@glider.be> wrote:
>> > Tested on Koelsch (legacy, reference, shmobile, and shmobile+bbb kernels)
>> > and BeagleBone Black (shmobile+bbb). Will test on more hardware tomorrow.
>>
>> Tested on genmai with Wolfram's CCF support.
>
> Thanks, shall I go ahead and queue this up?

Yes please, at least from my side everything looks perfect.

Cheers,

/ magnus
