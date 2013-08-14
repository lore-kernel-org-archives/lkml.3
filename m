Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933432Ab3HNW5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 18:57:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56198 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933374Ab3HNW5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 18:57:44 -0400
Date: Wed, 14 Aug 2013 15:57:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Caizhiyong <caizhiyong@huawei.com>
Cc: Karel Zak <kzak@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wanglin (Albert)" <albert.wanglin@huawei.com>,
        linux-mtd@lists.infradead.org
Subject: Re: [PATCH] block: add command line partition parser
Message-Id: <20130814155742.d3cd651e40e552696667e4f2@linux-foundation.org>
In-Reply-To: <C3050A4DBA34F345975765E43127F10F1C06237C@szxeml512-mbs.china.huawei.com>
References: <C3050A4DBA34F345975765E43127F10F1C061D75@szxeml512-mbs.china.huawei.com>
	<20130805152206.76462cc4a42e51b16a0532f1@linux-foundation.org>
	<C3050A4DBA34F345975765E43127F10F1C06237C@szxeml512-mbs.china.huawei.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Aug 2013 06:02:17 +0000 Caizhiyong <caizhiyong@huawei.com> wrote:

> move the command line parser to a separate module, and change it into
> library-style code.
> 
> reference: https://lkml.org/lkml/2013/8/6/550

Well OK.  But to prove the library's usefulness and to generally clean
up the kernel, someone needs to sign up to the task of converting
drivers/mtd/cmdlinepart.c to use this code.

I've been hopefully cc'ing various MTD people but am not being
overwhelmed with waves of enthusiasm ;)


