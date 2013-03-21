Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab3CUDRw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 23:17:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56535 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756576Ab3CUDRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 23:17:51 -0400
MIME-Version: 1.0
In-Reply-To: <514A7340.5040409@huawei.com>
References: <1363793126-11510-1-git-send-email-ming.lei@canonical.com>
	<1363793126-11510-2-git-send-email-ming.lei@canonical.com>
	<514A7340.5040409@huawei.com>
Date: Thu, 21 Mar 2013 11:17:48 +0800
Message-ID: <CACVXFVN7urpLM+Q-3o9=hYQLM=544WTXh+BnSo9fBM+d07oapQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] sysfs: fix race between readdir and lseek
From: Ming Lei <ming.lei@canonical.com>
To: Li Zefan <lizefan@huawei.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 10:41 AM, Li Zefan <lizefan@huawei.com> wrote:
>
> In fact the same race exists between readdir() and read()/write()...

Fortunately, no read()/write() are implemented on sysfs directory, :-)

Thanks,
--
Ming Lei
