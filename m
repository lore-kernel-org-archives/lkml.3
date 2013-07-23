Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933579Ab3GWQRe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 12:17:34 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:59683 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933436Ab3GWQRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 12:17:30 -0400
MIME-Version: 1.0
In-Reply-To: <20130723151009.GA5971@wolff.to>
References: <1374459663-15363-1-git-send-email-phillip@squashfs.org.uk>
	<20130723151009.GA5971@wolff.to>
Date: Tue, 23 Jul 2013 17:17:30 +0100
Message-ID: <CAB3wodfLzHMS1b3kQXKYvmWLLoYOhenwmMfS-cSU3w1gLFCh-g@mail.gmail.com>
Subject: Re: [PATCH 0/2] Squashfs: add LZ4 compression
From: Phillip Lougher <phillip.lougher@gmail.com>
To: Bruno Wolff III <bruno@wolff.to>
Cc: Phillip Lougher <phillip@squashfs.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 July 2013 16:10, Bruno Wolff III <bruno@wolff.to> wrote:
> On Mon, Jul 22, 2013 at 03:21:01 +0100,
>   Phillip Lougher <phillip@squashfs.org.uk> wrote:
>>
>> Hi
>>
>> Now that LZ4 compression support is in 3.11-rc1, I have written the
>> following two patches for Squashfs to use it.
>
>
> If this gets accepted are you going to move the LZ4 changes to
> squashfs-tools  into the stable branch? I'd like to make LZ4 work in
> mksquashfs in at least rawhide once LZ4 is usable for squashfs file systems
> in the kernel. So I was wondering whether to expect this to appear in stable
> shortly or to expect to start doing builds using the master branch.

Hmm, good point.... I was intending to merge the LZ4 work onto stable
yesterday or today, but, I've received more resistance to the idea of
LZ4 in Squashfs than I expected....  I'm not sure that merging LZ4
onto stable now gives the right message, because if it does not go
into mainline, it will effectively be experimental or abandoned.

In otherwords I don't think it's wise yet to merge LZ4 onto stable,
not until at least there's some positive feedback on the mailing list.

Thoughts?  Maybe some positive feedback? :-)

A V2 of the patches will be coming ASAP hopefully with some performance stats.


Thanks

Phillip
