Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab3I1Ku7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 06:50:59 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:39859 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab3I1Ku4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 06:50:56 -0400
MIME-Version: 1.0
In-Reply-To: <87zjqxkz70.fsf@igel.home>
References: <CALkWK0mwRbBkM=qvQPoyR+kEs8HwLx9P7bWWQnst_Z1=DRFkRA@mail.gmail.com>
 <CAHkRjk5_ep4poYY9gzcDgqaPuDtz2sgeZ0KPO6TqHttj-cS3xw@mail.gmail.com>
 <CALkWK0=YdxF43RQ-Fddp4Rzmx3aU3QdOPrjR=X+s6Wt9_RAYUg@mail.gmail.com>
 <20130927150156.GE26069@arm.com> <CALkWK0mjmGmhYnxBdMzbCXJn5yQyK63Ptqr6wT1pBurZCNtmNA@mail.gmail.com>
 <m2wqm1s6f5.fsf@linux-m68k.org> <CALkWK0nzk6s-C97ze4Ev8gY6fwPbf-qRCfCDvDDE56HFxvzw0A@mail.gmail.com>
 <m2siwps45q.fsf@linux-m68k.org> <CALkWK0=ii-usQ17qpwDMwCbJAPhDTghz6j8J7JEeZ5Uwnn-awQ@mail.gmail.com>
 <87zjqxkz70.fsf@igel.home>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Sat, 28 Sep 2013 16:20:15 +0530
Message-ID: <CALkWK0=ckOXhGO+NMdho5CBEKtK=mcVHCrMOaeZ97PLqSqu1cw@mail.gmail.com>
Subject: Re: [QUERY] Building and testing Aarch64
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Schwab wrote:
> You need all the other relevant virtio options built-in, too, like
> VIRTIO_BLK.

Thanks! VIRTIO_BLK was the missing feature. I'll submit patches shortly.
