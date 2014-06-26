Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719AbaFZJVM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 05:21:12 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:41997 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbaFZJVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 05:21:10 -0400
MIME-Version: 1.0
X-Originating-IP: [80.196.35.44]
In-Reply-To: <20140626074033.GA26094@infradead.org>
References: <1403651531-24891-1-git-send-email-m@bjorling.me>
	<1403651531-24891-2-git-send-email-m@bjorling.me>
	<20140625113715.GA4525@infradead.org>
	<CAOu_J6nTcEjEpAe+S7Wg9SxUj_u=QitsDjYkKmCpaGP1MAexhw@mail.gmail.com>
	<20140626074033.GA26094@infradead.org>
Date: Thu, 26 Jun 2014 11:21:09 +0200
Message-ID: <CAOu_J6mfpmQ7N4nfeo9ecD7esF=VMhbmHdgAb=qQMf4DS5_W2w@mail.gmail.com>
Subject: Re: [PATCH v9] NVMe: Convert to blk-mq
From: =?UTF-8?Q?Matias_Bj=C3=B8rling?= <m@bjorling.me>
To: Christoph Hellwig <hch@infradead.org>
Cc: Keith Busch <keith.busch@intel.com>, Rob Nelson <rlnelson@google.com>,
        Jens Axboe <axboe@fb.com>, Ming Lei <tom.leiming@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-nvme <linux-nvme@lists.infradead.org>,
        Matthew Wilcox <willy@linux.intel.com>,
        "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 9:40 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Jun 25, 2014 at 08:56:35PM +0200, Matias Bj??rling wrote:
>> Only the review. Do you want me to change it to a Reviewed-by?
>
>
> I've not really don't a formal review of the latest patch yet.  I plan
> to do it, and will give me Reviewed-by-tag then.  For now I don't think
> I'm actually significant enough to be mentioned in the patch.

Ok

>
> If you need to fill the patch description some details on the conversion
> and performance numbers might be useful :)
>

Agree, I was thinking of doing this now that the changes have cooled
down. Thanks. :)
