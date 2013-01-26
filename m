Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab3AZW2n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 17:28:43 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51898 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484Ab3AZW2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 17:28:41 -0500
MIME-Version: 1.0
In-Reply-To: <20130126104634.997ac68f6971397b9f4d09d3@canb.auug.org.au>
References: <20130125162606.edff84fcf6f62ed2b7c4d719@canb.auug.org.au>
	<5102B8A6.3090200@infradead.org>
	<20130126104634.997ac68f6971397b9f4d09d3@canb.auug.org.au>
Date: Sat, 26 Jan 2013 23:57:00 +0200
Message-ID: <CAEbWaipy03Rg=KQZg3-aOX3t_-za3Ud-zCAxKoFVED1d7tZnfA@mail.gmail.com>
Subject: Re: linux-next: Tree for Jan 25 (kvm)
From: Avi Kivity <avi.kivity@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Randy Dunlap <rdunlap@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, KVM <kvm@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, 2013 at 1:46 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> On Fri, 25 Jan 2013 08:53:58 -0800 Randy Dunlap <rdunlap@infradead.org> wrote:
>>
>> Seeing lots of this error on i386:
>>
>> arch/x86/kvm/emulate.c:1016: Error: unsupported for `push'
>
> Caused by commit 9ae9febae950 ("KVM: x86 emulator: covert SETCC to
> fastop") from the kvm tree.  cc's added.
>


I posted a fix.
