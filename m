Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756AbaKQD01 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 22:26:27 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:41963 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbaKQD00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 22:26:26 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1411161947540.3909@nanos>
References: <20141114204517.GA24402@www.outflux.net>
	<CAE9FiQULexNgTYCrQgQK+ccNTVDyiJCWkgiDVgbPG-5SY0uPGQ@mail.gmail.com>
	<CAE9FiQV=i=+tO2Xum0EYdnqjqso1=twHUfjGZHEASVhUGE-x2g@mail.gmail.com>
	<CAGXu5j+8sEhgmHtdky7G5X2arRsSQSjA=xxuBPPZZAP7v046dg@mail.gmail.com>
	<CAE9FiQVAWYdZvq3QDn-=06QX0+H=RynSS+VVmvTyAaU1BECR_g@mail.gmail.com>
	<alpine.DEB.2.11.1411161947540.3909@nanos>
Date: Sun, 16 Nov 2014 19:26:25 -0800
X-Google-Sender-Auth: 7Ezs42plvTfpqVTom8i5Mvkt3BA
Message-ID: <CAE9FiQUQEnXA-vX2L3VhSucNbRf3u8Afmn=M0CoXHeUyPhuAOA@mail.gmail.com>
Subject: Re: [PATCH v2] x86, mm: set NX across entire PMD at boot
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Kees Cook <keescook@chromium.org>,
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

On Sun, Nov 16, 2014 at 10:52 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> >
>> > Are you sure? For me, _brk_end isn't far enough:
>> >
>> > [    1.475572] all_end: 0xffffffff82df5000
>> > [    1.476736] _brk_end: 0xffffffff82dd6000
>>
>> Yes. _brk_end should be small then &_end.
>
> Wrong. _brk_end can move up to _end, i.e. to __brk_limit.

Confused. What is wrong? _brk_end is not smaller than &_end?

Yinghai
