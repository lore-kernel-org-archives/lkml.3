Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab3GALnr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 07:43:47 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:49348 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab3GALnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 07:43:46 -0400
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
	<874ncek4q1.fsf@devron.myhome.or.jp>
	<CAO+d-qqs0uUqNcmOhgZdKeaJQxd5y+TyKVFSpgknoUkX2YidfQ@mail.gmail.com>
Date: Mon, 01 Jul 2013 20:43:43 +0900
In-Reply-To: <CAO+d-qqs0uUqNcmOhgZdKeaJQxd5y+TyKVFSpgknoUkX2YidfQ@mail.gmail.com>
	(dmitry pervushin's message of "Mon, 1 Jul 2013 12:53:35 +0200")
Message-ID: <87wqpaijyo.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dmitry pervushin <dpervushin@gmail.com> writes:

> Honestly, I do not understand why getting volume id might be the
> function of the mounted filesystem. I'd rather think about generic
> function "filesystem id" of the block device.

I see. Yes, I have same question too.

> But if we decided to implement getting volume id from the filesystem,
> then getting it from the root of the filesystem (but not from any
> subdirectory of it and even not from files) makes sense for me.

Hm, finding the mount point and open fd (for only this) would be
inconvenient, and need some costs.  Especially, if user is using the
bind mount.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
