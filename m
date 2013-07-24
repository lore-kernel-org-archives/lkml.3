Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943Ab3GXRzU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 13:55:20 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:36505 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab3GXRzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 13:55:16 -0400
Message-ID: <51F014FC.70104@twiddle.net>
Date: Wed, 24 Jul 2013 07:55:08 -1000
From: Richard Henderson <rth@twiddle.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Michael Cree <mcree@orcon.net.nz>, Michael Cree <cree@waikato.ac.nz>,
        Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        ink@jurassic.park.msu.ru, mattst88@gmail.com,
        linux-alpha@vger.kernel.org
Subject: Re: [PATCH 0/7] Minor Alpha updates for 3.11
References: <20130717000347.GB2483@stolen.phys.waikato.ac.nz> <1374546701.3719.33@driftwood> <20130723032511.GA18086@stolen.phys.waikato.ac.nz> <51EE9F36.7050402@twiddle.net> <20130724102544.GA7713@omega>
In-Reply-To: <20130724102544.GA7713@omega>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2013 12:25 AM, Michael Cree wrote:
> Searching for NR_umount finds the following packages that compile on
> Alpha:
> 
> eglibc

Fork of glibc, which I did examine; I'll assume it's the same code.

> dietlibc
> uclibc

Rob reports that uclibc is fixed by the rename.  From what I see in
the dietlibc source, the same is true of Alpha, since the only mention
of "oldumount" is in alpha/syscalls.h.

> qemu

Definitely would be fixed by the rename.

Of course in both dietlibc and qemu, the packages need to be patched
to match the kernel rename, as they don't use the kernel headers.

> radare

Repository has vanished?  There's a radare2 that apparently superceeds
it, but doesn't mention umount in any relevant context.

> linux-tools
> ns3
> skyeye

I can't find source for these to browse.


r~
