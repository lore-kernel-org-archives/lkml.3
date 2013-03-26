Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759428Ab3CZIpf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 04:45:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51184 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591Ab3CZIpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 04:45:32 -0400
MIME-Version: 1.0
In-Reply-To: <51514EA9.8080801@huawei.com>
References: <1363793126-11510-1-git-send-email-ming.lei@canonical.com>
	<1363793126-11510-2-git-send-email-ming.lei@canonical.com>
	<514A7340.5040409@huawei.com>
	<CACVXFVN7urpLM+Q-3o9=hYQLM=544WTXh+BnSo9fBM+d07oapQ@mail.gmail.com>
	<514A7E72.2090200@huawei.com>
	<CACVXFVMS644BpX7voMHS-xXoRs9-G4y96=ubk_NAj6KDTy1ENQ@mail.gmail.com>
	<514BF0BE.1070907@huawei.com>
	<CACVXFVOAFqVoNP-igJ-WeaJ+rKF-gREcHqspHWOkz4EJ9Gn94w@mail.gmail.com>
	<51514EA9.8080801@huawei.com>
Date: Tue, 26 Mar 2013 16:45:29 +0800
Message-ID: <CACVXFVPLkaoowZJZdrg3nkm7ymismJ6W=_BzgyroKJOxJYPODA@mail.gmail.com>
Subject: Re: [PATCH 1/2] sysfs: fix race between readdir and lseek
From: Ming Lei <ming.lei@canonical.com>
To: Li Zefan <lizefan@huawei.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 3:30 PM, Li Zefan <lizefan@huawei.com> wrote:
>> Considered that vfs_read()/vfs_write on sysfs dir is almost doing nothing, the
>> above problem may only exist in theory.
>
> The read() vs readdir() race in sysfs directory doesn't exist in theory only.

Could you let me know if you have applied the two patches on your test?

https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/?id=e5110f411d2ee35bf8d202ccca2e89c633060dca

https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/?id=991f76f837bf22c5bb07261cfd86525a0a96650c

Also I appreciate it if you may share your test case...

Thanks,
--
Ming Lei
