Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab3KGCgK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 21:36:10 -0500
Received: from mail-vb0-f51.google.com ([209.85.212.51]:48275 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab3KGCgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 21:36:06 -0500
MIME-Version: 1.0
In-Reply-To: <CAFRkauAEt-YhBt11opj_GVCLrxGsTSd2LowWGmukTSmGuJkd3A@mail.gmail.com>
References: <1383789208.5970.1.camel@phoenix>
	<CACVXFVMn6RSXchQ8u47F35_J+YSnp1bwF1tr-8uCEYwvFsOfgQ@mail.gmail.com>
	<CAFRkauAEt-YhBt11opj_GVCLrxGsTSd2LowWGmukTSmGuJkd3A@mail.gmail.com>
Date: Thu, 7 Nov 2013 10:36:04 +0800
Message-ID: <CACVXFVO=QA-R1+twCL9fc_3vASg6Ap-3ezi=tU1MV1pdPYrfWw@mail.gmail.com>
Subject: Re: kernel BUG at kernel/kallsyms.c:222!
From: Ming Lei <tom.leiming@gmail.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Russell King <linux@arm.linux.org.uk>, Michal Marek <mmarek@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 7, 2013 at 10:18 AM, Axel Lin <axel.lin@ingics.com> wrote:
> 2013/11/7 Ming Lei <tom.leiming@gmail.com>:
>> Could you share what is the value of CONFIG_PAGE_OFFSET
>> on your noMMU platform?
>
> $ grep  CONFIG_PAGE_OFFSET .config
> CONFIG_PAGE_OFFSET=0xC0000000

It seems that the PAGE_OFFSET is _not_ the start of kernel memory
in linear address space on your platform, I think it may not be a correct
usage, even for uClinux.


Thanks,
-- 
Ming Lei
