Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbaFPPbn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 11:31:43 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:46225 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312AbaFPPbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 11:31:40 -0400
MIME-Version: 1.0
In-Reply-To: <20140616143801.GJ5714@two.firstfloor.org>
References: <cover.1402769596.git.luto@amacapital.net>
	<21405.44257.742122.786960@gargle.gargle.HOWL>
	<20140615143500.GP179@brightrain.aerifal.cx>
	<539DD26B.3060709@zytor.com>
	<CALCETrXTpkto2gJBiFC4CR5D=Lqf2YfP5BBH02f8hFW+TUGqeA@mail.gmail.com>
	<539DDE9C.3010903@zytor.com>
	<CALCETrWLBCNiJArMRPuHbfhj6=ytnx_YqykzgCgZ+DYu34M1Mg@mail.gmail.com>
	<20140616023604.GI5714@two.firstfloor.org>
	<CAKOQZ8wwKcDAXq0BnHwvL01LQNFeOGwgA9x8kCLWeFaP6USF4A@mail.gmail.com>
	<20140616143801.GJ5714@two.firstfloor.org>
Date: Mon, 16 Jun 2014 08:31:39 -0700
X-Google-Sender-Auth: ZsoNlXZzFhYryqiduj12Y5by9S8
Message-ID: <CAKOQZ8zk8KfkObSZg8fmhZXm9nXQSneOywvV-NBj=N-tNWjNPg@mail.gmail.com>
Subject: Re: [RFC 0/2] __vdso_findsym
From: Ian Lance Taylor <iant@golang.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>,
        Rich Felker <dalias@libc.org>,
        Mikael Pettersson <mikpelinux@gmail.com>, Russ Cox <rsc@golang.org>,
        Linux API <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 7:38 AM, Andi Kleen <andi@firstfloor.org> wrote:
>> I think this issue started when some of the Go developers questioned
>> why the kernel needed to provide a very complex interface--parsing an
>> ELF shared shared library--for very simple functionality--looking up
>> the address of a magic function.  This approach has required special
>> support not just in Go, but also in the dynamic linker and gdb, and
>> does not work well for statically linked binaries.  The support in gdb
>> is perhaps a good idea, but elsewhere it does not make sense.
>>
>> So why not provide a simple interface?
>
> What good would it do now that everyone already supports it?

Do statically linked binaries use the vDSO calls?

Ian
