Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542AbaDPU5Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 16:57:16 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:34597 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754920AbaDPU5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 16:57:14 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <534EC04F.9010408@gmail.com>
References: <1387309071-22382-1-git-send-email-ynvich@gmail.com> <1397668411-27162-1-git-send-email-ynvich@gmail.com> <534EC04F.9010408@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 00/21] ARM: support for ICP DAS LP-8x4x (with dts)
From: Sergei Ianovich <ynvich@gmail.com>
Date: Thu, 17 Apr 2014 00:59:08 +0400
To: Daniel Mack <zonque@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
CC: Arnd Bergmann <arnd@arndb.de>, Haojian Zhuang <haojian.zhuang@gmail.com>
Message-ID: <610ed273-1e54-4d44-b523-cbe0d042cf48@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Mack <zonque@gmail.com> wrote:
>Hi,
>
>On 04/16/2014 07:13 PM, Sergei Ianovich wrote:
>> We had an intensive discussion of the series in the beginning of
>> December 2013 [1]. The discussion resulted in 3 versions of the
>series
>> in less than 3 weeks. Then there was a decision to block this series
>> until Daniel Mack's DMA-engine-for-PXA series is ready.
>
>For whatever reason, I only received patches 1-8 out of 21 in this
>series.

The rest is related to exotic parts of the tree and 'scripts/get_maintainer.pl' decided not to spam you. The whole series is sent to both lkml and arm lists. I can add you to cc by hand if you are interested. 

>> Unfortunately Daniel neigther agrees to review my trivial temporary
>> solution to the DMA-in-device-tree (patch 7 of 21), nor he is active
>> in DMA series development. There is no progress for 3 months.
>
>Well, IIRC, I asked you to look into the MMC performance regressions
>that you reported and see what we can do about them. I currently don't
>have hardware to reproduce this, so I can't do it myself.

I hate to point fingers, but you promissed to refresh the code on several occasions. It is from 3.8 tree at the moment. The regression may be introduced by an error in my merging of your patches. I published the one I tested in one piece with the results. 

>My impression is that the transisiton will only be painless if the
>mmp_pdma driver provides comparable performance to the existing
>implementation. I also still think that adding hacks to the drivers to
>manually parse the dma properties (as in #8) brings us further away
>from
>a proper solution, not closer

No doubt about that. But the regression is not the only problem. Driver for video capture requires an extensive rewrite as well. The result is that a working pxa DT device is kept out of the tree and there is no supported DT devices in tree. So no proper examples for new devices and no drive-by improvements. All of this prevents rather than facilitates eventual DT migration of tha PXA platform.

