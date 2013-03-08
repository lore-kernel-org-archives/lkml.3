Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933742Ab3CHHDi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 02:03:38 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:50600 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab3CHHDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 02:03:37 -0500
MIME-Version: 1.0
In-Reply-To: <20130308060410.GH14556@mtj.dyndns.org>
References: <1362718720-27048-1-git-send-email-yinghai@kernel.org>
	<1362718720-27048-7-git-send-email-yinghai@kernel.org>
	<20130308060410.GH14556@mtj.dyndns.org>
Date: Thu, 7 Mar 2013 23:03:36 -0800
X-Google-Sender-Auth: vBubTzyf5UK_B8Fs5CFz4_GC7Q4
Message-ID: <CAE9FiQWq=oBvvAReCNXcejE-w+cAB-xu2rrBtmvBYAYeAkCLyg@mail.gmail.com>
Subject: Re: [PATCH 06/14] x86, mm, numa: Move successful path handling code later
From: Yinghai Lu <yinghai@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 7, 2013 at 10:04 PM, Tejun Heo <tj@kernel.org> wrote:
>>  static int __init numa_register_memblks(struct numa_meminfo *mi)
>
> After this patch, the above name is a bit misleading, I think.

later i changed it to numa_check_memblks()

Thanks

Yinghai
