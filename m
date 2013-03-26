Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934425Ab3CZODg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 10:03:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52905 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932383Ab3CZODe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 10:03:34 -0400
MIME-Version: 1.0
In-Reply-To: <CACVXFVPLkaoowZJZdrg3nkm7ymismJ6W=_BzgyroKJOxJYPODA@mail.gmail.com>
References: <1363793126-11510-1-git-send-email-ming.lei@canonical.com>
	<1363793126-11510-2-git-send-email-ming.lei@canonical.com>
	<514A7340.5040409@huawei.com>
	<CACVXFVN7urpLM+Q-3o9=hYQLM=544WTXh+BnSo9fBM+d07oapQ@mail.gmail.com>
	<514A7E72.2090200@huawei.com>
	<CACVXFVMS644BpX7voMHS-xXoRs9-G4y96=ubk_NAj6KDTy1ENQ@mail.gmail.com>
	<514BF0BE.1070907@huawei.com>
	<CACVXFVOAFqVoNP-igJ-WeaJ+rKF-gREcHqspHWOkz4EJ9Gn94w@mail.gmail.com>
	<51514EA9.8080801@huawei.com>
	<CACVXFVPLkaoowZJZdrg3nkm7ymismJ6W=_BzgyroKJOxJYPODA@mail.gmail.com>
Date: Tue, 26 Mar 2013 22:03:31 +0800
Message-ID: <CACVXFVMukhkriwZUEeZN6XWcogUmGE67WkNYv7mZ7pqdRHM47Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] sysfs: fix race between readdir and lseek
From: Ming Lei <ming.lei@canonical.com>
To: Li Zefan <lizefan@huawei.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Zefan,

On Tue, Mar 26, 2013 at 4:45 PM, Ming Lei <ming.lei@canonical.com> wrote:
> On Tue, Mar 26, 2013 at 3:30 PM, Li Zefan <lizefan@huawei.com> wrote:
>>> Considered that vfs_read()/vfs_write on sysfs dir is almost doing nothing, the
>>> above problem may only exist in theory.
>>
>> The read() vs readdir() race in sysfs directory doesn't exist in theory only.
>
> Could you let me know if you have applied the two patches on your test?
>
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/?id=e5110f411d2ee35bf8d202ccca2e89c633060dca
>
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/?id=991f76f837bf22c5bb07261cfd86525a0a96650c
>
> Also I appreciate it if you may share your test case...

If you mean the test code on link[1], I can't reproduce the
warning with the two sysfs fix patches in 4 hours's test.

[1], https://patchwork.kernel.org/patch/2160771/

Thanks,
--
Ming Lei
