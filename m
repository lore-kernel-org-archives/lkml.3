Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbaKQUna (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 15:43:30 -0500
Received: from mail-oi0-f53.google.com ([209.85.218.53]:58733 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbaKQUn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 15:43:28 -0500
MIME-Version: 1.0
In-Reply-To: <20141117203213.GA4042@n2100.arm.linux.org.uk>
References: <20141114204517.GA24402@www.outflux.net>
	<CAE9FiQULexNgTYCrQgQK+ccNTVDyiJCWkgiDVgbPG-5SY0uPGQ@mail.gmail.com>
	<CAE9FiQV=i=+tO2Xum0EYdnqjqso1=twHUfjGZHEASVhUGE-x2g@mail.gmail.com>
	<CAGXu5j+8sEhgmHtdky7G5X2arRsSQSjA=xxuBPPZZAP7v046dg@mail.gmail.com>
	<alpine.DEB.2.11.1411162127310.3909@nanos>
	<CAGXu5jKynZtTu8T333v+ZeUSfhQxgOmc6S3g-GuZzN_e4FvP5Q@mail.gmail.com>
	<20141117203213.GA4042@n2100.arm.linux.org.uk>
Date: Mon, 17 Nov 2014 12:43:27 -0800
X-Google-Sender-Auth: cjMKPLQd7Da63wt9hpD8rTJjfl4
Message-ID: <CAGXu5jLaFHHpkag1TOXsy1d63izJQGpmQ61=tuvJL0VnZYX9qg@mail.gmail.com>
Subject: Re: [PATCH v2] x86, mm: set NX across entire PMD at boot
From: Kees Cook <keescook@chromium.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>, Laura Abbott <lauraa@codeaurora.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Wang Nan <wangnan0@huawei.com>, David Vrabel <david.vrabel@citrix.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 12:32 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, Nov 17, 2014 at 12:27:59PM -0800, Kees Cook wrote:
>> I have a series for arm that is waiting to be picked up by rmk:
>> https://patchwork.ozlabs.org/patch/400383/
>
> It should've been in linux-next via my tree for the last two weeks
> or so.

Fantastic! Thank you!

-Kees

-- 
Kees Cook
Chrome OS Security
