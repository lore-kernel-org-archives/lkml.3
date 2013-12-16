Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab3LPRgy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 12:36:54 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:60587 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143Ab3LPRgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 12:36:53 -0500
MIME-Version: 1.0
In-Reply-To: <20131216113510.GA5211@cpaasch-mac>
References: <20131216113510.GA5211@cpaasch-mac>
Date: Mon, 16 Dec 2013 09:36:52 -0800
Message-ID: <CAM_iQpUTTNbJLCNDem0xOCGW7XWctEyQ3H2w-1=y0HkhJ4uWhg@mail.gmail.com>
Subject: Re: BUG: crashkernel does not boot upon crash from sysrq-trigger
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Christoph Paasch <christoph.paasch@uclouvain.be>
Cc: LKML <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
        Ian Fang <ianfang.cn@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 3:35 AM, Christoph Paasch
<christoph.paasch@uclouvain.be> wrote:
> Hello,
>
> since 3.5, my crashkernel does not boot anymore when triggering an oops with
> /proc/sysrq-trigger on my HP Elitebook 8540p.
>
> I bisected it down to 722bc6b16771ed8 (x86/mm: Fix the size calculation of
> mapping tables).
>

It has been reverted in upstream.
