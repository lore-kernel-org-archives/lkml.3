Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311AbaGaNEI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 09:04:08 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:46135 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbaGaNEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 09:04:06 -0400
MIME-Version: 1.0
In-Reply-To: <53DA3C5C.3040508@excello.cz>
References: <53DA3C5C.3040508@excello.cz>
Date: Thu, 31 Jul 2014 15:04:03 +0200
Message-ID: <CAFLxGvz5ph_Sk7XmtCMzSCMj-nOPFm8=phoc3Ng_+gyFjTDh7A@mail.gmail.com>
Subject: Re: Sudden kernel panics on AMD Opteron platforms with hardened kernel
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Jan Hejl <jh@excello.cz>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 2:53 PM, Jan Hejl <jh@excello.cz> wrote:
> Hello,
>
> i'm facing sudden kernel panics. Last one happened few minutes ago.
> Unfortunatelly only output that i've catched is limited thanks to low
> resolution of console screen. See screenshot attached.
>
> Below is output of the ver_linux script.
>
> Linux aq 3.14.12-hardened-r2 #1 SMP Tue Jul 22 18:47:50 CEST 2014 x86_64 AMD

Does the problem also happen with a vanilla kernel?

> Opteron(tm) Processor 6376 AuthenticAMD GNU/Linux
>  Gnu C                  4.7.3
> Gnu make               3.82
> binutils               2.23.2
> util-linux             scripts/ver_linux: line 23: fdformat: command not
> found
> mount                  assert
> module-init-tools      18
> e2fsprogs              1.42.10
> xfsprogs               3.1.10
> Linux C Library        Dynamic linker (ldd)   2.17
> Procps                 3.3.9
> Net-tools              1.60_p20130513023548
> Kbd                    1.15.5
> Sh-utils               8.21
> Modules Loaded
>
> Can you please point to me to a right direction where to start with
> debugging of this panic? It is badly reproducible because it happens
> randomly.
>
> Hope you'll find all info attached.
>
> Thanks for any help!
> Jan
>



-- 
Thanks,
//richard
