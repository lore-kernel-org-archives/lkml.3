Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab3I1KjU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 06:39:20 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:57248 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab3I1KjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 06:39:18 -0400
X-Auth-Info: 175h+AvraF4W/sJZ36r5qgxoz2E1SUqj3Q65aBR2V3E=
From: Andreas Schwab <schwab@linux-m68k.org>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [QUERY] Building and testing Aarch64
References: <CALkWK0mwRbBkM=qvQPoyR+kEs8HwLx9P7bWWQnst_Z1=DRFkRA@mail.gmail.com>
	<CAHkRjk5_ep4poYY9gzcDgqaPuDtz2sgeZ0KPO6TqHttj-cS3xw@mail.gmail.com>
	<CALkWK0=YdxF43RQ-Fddp4Rzmx3aU3QdOPrjR=X+s6Wt9_RAYUg@mail.gmail.com>
	<20130927150156.GE26069@arm.com>
	<CALkWK0mjmGmhYnxBdMzbCXJn5yQyK63Ptqr6wT1pBurZCNtmNA@mail.gmail.com>
	<m2wqm1s6f5.fsf@linux-m68k.org>
	<CALkWK0nzk6s-C97ze4Ev8gY6fwPbf-qRCfCDvDDE56HFxvzw0A@mail.gmail.com>
	<m2siwps45q.fsf@linux-m68k.org>
	<CALkWK0=ii-usQ17qpwDMwCbJAPhDTghz6j8J7JEeZ5Uwnn-awQ@mail.gmail.com>
X-Yow: Barbie says, Take quaaludes in gin and go to a disco right away!
 But Ken says, WOO-WOO!!  No credit at ``Mr. Liquor''!!
Date: Sat, 28 Sep 2013 12:39:15 +0200
In-Reply-To: <CALkWK0=ii-usQ17qpwDMwCbJAPhDTghz6j8J7JEeZ5Uwnn-awQ@mail.gmail.com>
	(Ramkumar Ramachandra's message of "Sat, 28 Sep 2013 15:09:42 +0530")
Message-ID: <87zjqxkz70.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ramkumar Ramachandra <artagnon@gmail.com> writes:

> Unfortunately, even with VIRTIO_MMIO built in, I get the same error:

You need all the other relevant virtio options built-in, too, like
VIRTIO_BLK.

> The transcript from the working linux-system.axf (with raring-rootfs)
> looks like:

>From there you can extract the config from /proc/config.gz.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
