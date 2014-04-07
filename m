Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592AbaDGVZ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 17:25:59 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:63737 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771AbaDGVZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 17:25:57 -0400
MIME-Version: 1.0
In-Reply-To: <20140407204221.GW32556@tassilo.jf.intel.com>
References: <52E4CF03.8030208@archlinux.org>
	<5339F739.2060207@archlinux.org>
	<20140331233450.GI32556@tassilo.jf.intel.com>
	<5339FC62.8060207@archlinux.org>
	<20140405011332.GR32556@tassilo.jf.intel.com>
	<5340134B.4010705@archlinux.org>
	<20140407173016.GU32556@tassilo.jf.intel.com>
	<5342E46B.4080603@archlinux.org>
	<53430646.40507@archlinux.org>
	<20140407204221.GW32556@tassilo.jf.intel.com>
Date: Mon, 7 Apr 2014 22:25:56 +0100
Message-ID: <CAL01qpvjZz-XnVT+S3E5E2XGcuFoetE5cwnArYfW-TwYZVKtKw@mail.gmail.com>
Subject: Re: 3.13: <module> disagrees about version of symbol <symbol>
From: "Fleming, Matt" <matt.fleming@intel.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: =?ISO-8859-1?Q?Thomas_B=E4chler?= <thomas@archlinux.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        tpowa@archlinux.org, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 April 2014 21:42, Andi Kleen <ak@linux.intel.com> wrote:
>
> This sounds like the UEFI boot corrupts some memory?

Hmpf, yeah. I'll take a look in the morning.

Thomas, you mention you're running in a 32-bit vm earlier in this
thread. Any chance you're using ovmf because that would make it much
easier to track this down?
