Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab3GAJaF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 05:30:05 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:49309 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037Ab3GAJaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 05:30:03 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: dmitry pervushin <dpervushin@gmail.com>
Cc: Bintian Wang <bintian.wang@linaro.org>, linux-kernel@vger.kernel.org,
        Mike Lockwood <lockwood@android.com>, Colin Cross <ccross@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH RFC] Add FAT_IOCTL_GET_VOLUME_ID
References: <1372646398-4204-1-git-send-email-bintian.wang@linaro.org>
	<87wqpakdvd.fsf@devron.myhome.or.jp>
	<87sizykdjg.fsf@devron.myhome.or.jp>
	<CAJ2TvK=SVMfuFw+U46z-iCS1sYZgnmdk+sr30NeNFTayot7g8g@mail.gmail.com>
	<CAO+d-qrq9XD2d0FtoA7ZkCsSkka0sfgERb-OeNoU2kLXpF+PVA@mail.gmail.com>
Date: Mon, 01 Jul 2013 18:29:58 +0900
In-Reply-To: <CAO+d-qrq9XD2d0FtoA7ZkCsSkka0sfgERb-OeNoU2kLXpF+PVA@mail.gmail.com>
	(dmitry pervushin's message of "Mon, 1 Jul 2013 10:49:28 +0200")
Message-ID: <874ncek4q1.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dmitry pervushin <dpervushin@gmail.com> writes:

> Hello Bintian,
>
> The original idea discussed with John was to allow
> FAT_IOCTL_GET_VOLUME_ID (broken or not) only on directory nodes, and
> even on the root directory node. That's why it is should be *not* in
> fat_generic_ioctl.

The question would be, why do we have to limit only on directory?

When I'm reviewing this, I recalled fstatvfs(2) as referenced one. The
both get the info of fs. fstatvfs(2) doesn't limit only on
directory. But, in the FAT_IOCTL_GET_VOLUME_ID case, it limits.

I wonder why?

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
