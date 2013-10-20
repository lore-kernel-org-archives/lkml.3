Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751159Ab3JTM7R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 08:59:17 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53750 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab3JTM7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 08:59:16 -0400
MIME-Version: 1.0
In-Reply-To: <20131020123521.GA15627@thunk.org>
References: <CABjrhvqTHkuEyQ=-xaud5Y0i3YqYcdBsm2eWrR-44V=OESWypg@mail.gmail.com>
	<F713E780-33E1-494C-ADAD-92211724209E@dubeyko.com>
	<CABjrhvqLgVSEOJVuS1n-R_kyvhFouUqhfjqS4P_jsPGAec+KdQ@mail.gmail.com>
	<20131020123521.GA15627@thunk.org>
Date: Sun, 20 Oct 2013 20:59:14 +0800
Message-ID: <CABjrhvpzcETE=CZrOkRgxpKhFm9-piYJLJ=8zdwnNkmJtkWRtQ@mail.gmail.com>
Subject: Re: [RFC] Rollback FS
From: jiaweiwei <jiaweiwei.xiyou@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>, jiaweiwei <jiaweiwei.xiyou@gmail.com>,
        Vyacheslav Dubeyko <slava@dubeyko.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Harry Wei <harryxiyou@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 20, 2013 at 8:35 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Sun, Oct 20, 2013 at 07:37:01PM +0800, jiaweiwei wrote:
>>
>> Any file system should rollback but not specific ones. Therefore, a
>> VFS like mechanism should be designed and implemented.
>
> And what if the blocks or inodes used for the files that were deleted
> have already been used and overwritten?

A good catch. Following ideas would be suitable.

1, Keep the blocks or inodes by a parameter we give.
2, Keep the blocks or inodes for several seconds.

>
>> Maybe, I would give detail design, thanks.
>
> I encourage you to try to do that; you might find it to be an
> educational exercise.
>

Yeah, I would, thanks.


-- 
 do kernel
