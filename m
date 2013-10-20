Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523Ab3JTLqk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 07:46:40 -0400
Received: from mail-vb0-f54.google.com ([209.85.212.54]:35759 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab3JTLqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 07:46:39 -0400
MIME-Version: 1.0
In-Reply-To: <CABjrhvqLgVSEOJVuS1n-R_kyvhFouUqhfjqS4P_jsPGAec+KdQ@mail.gmail.com>
References: <CABjrhvqTHkuEyQ=-xaud5Y0i3YqYcdBsm2eWrR-44V=OESWypg@mail.gmail.com>
	<F713E780-33E1-494C-ADAD-92211724209E@dubeyko.com>
	<CABjrhvqLgVSEOJVuS1n-R_kyvhFouUqhfjqS4P_jsPGAec+KdQ@mail.gmail.com>
Date: Sun, 20 Oct 2013 13:46:38 +0200
Message-ID: <CAFLxGvwgf3dD=4Xf_JtFwPFtudRYg8RuL8Jcu5dJr3CfkdnvVg@mail.gmail.com>
Subject: Re: [RFC] Rollback FS
From: Richard Weinberger <richard.weinberger@gmail.com>
To: jiaweiwei <jiaweiwei.xiyou@gmail.com>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Harry Wei <harryxiyou@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 20, 2013 at 1:37 PM, jiaweiwei <jiaweiwei.xiyou@gmail.com> wrote:
> On Sun, Oct 20, 2013 at 6:43 PM, Vyacheslav Dubeyko <slava@dubeyko.com> wrote:
>> Anyway, you need to use Copy-On-Write (COW) approach for such file system.
>> But there are file systems that implements snapshot approach yet: NILFS2, ext3cow,
>> Next3, and so on.
>>
>
> Any file system should rollback but not specific ones. Therefore, a
> VFS like mechanism should be designed and implemented.

-ENOPATCH

>> Do you really want to implement something likewise snapshot feature in a file system
>> from the scratch?
>>
>
> Maybe, I would give detail design, thanks.

Linux's next generation filesystem, btrfs, has already support for
file and volume level snapshots.

-- 
Thanks,
//richard
