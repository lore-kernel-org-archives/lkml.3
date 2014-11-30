Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbaK3LL7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 06:11:59 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:42091 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbaK3LL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 06:11:58 -0500
MIME-Version: 1.0
In-Reply-To: <1417258323.9558.3.camel@gmail.com>
References: <1417258323.9558.3.camel@gmail.com>
Date: Sun, 30 Nov 2014 12:11:57 +0100
Message-ID: <CAFLxGvwKwZh38+-is8dX6zOFAiz0gVo+Yio3B=2eiMqmGCZfqA@mail.gmail.com>
Subject: Re: Crash when copying from broken external hdd
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Simon Danner <danner.simon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 29, 2014 at 11:52 AM, Simon Danner <danner.simon@gmail.com> wrote:
> Hello,
> i get the following crash after i try to copy files from a broken
> external hdd to another external hdd.
> It happens after a few minutes, with latest git and 3.17.4 from Arch.
> Attached screenshot is from latest mainline git.
>
> i hope this can be fixed somehow,
> Regards Simon Danner

Can you decode scsi_requed_end+0x122?
CC'ing block and scsi folks.

-- 
Thanks,
//richard
