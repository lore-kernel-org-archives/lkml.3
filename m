Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759393Ab3EOPDU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 11:03:20 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:55389 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759188Ab3EOPDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 11:03:19 -0400
Message-ID: <5193A3B0.3000909@gmail.com>
Date: Wed, 15 May 2013 23:03:12 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] x86, cleanup: minor cleanups for reserve_crashkernel
References: <51939C3F.4060207@gmail.com>
In-Reply-To: <51939C3F.4060207@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for sending the wrong patch. Please ignore this.

Thanks
Zhang

于 2013年05月15日 22:31, Zhang Yanfei 写道:
> patch 1 fixes an out-of-data comment.
> patch 2 uses pr_info instead of printk.
> 
> Zhang Yanfei (2):
>   x86, kexec: Correct comment in reserve_crashkernel
>   x86, setup: Use pr_info instead of printk(KERN_INFO...)
> 
>  arch/x86/kernel/setup.c |   13 +++++++------
>  1 files changed, 7 insertions(+), 6 deletions(-)

