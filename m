Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbaLWIaP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 03:30:15 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:32991 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873AbaLWIaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 03:30:13 -0500
Message-ID: <54992809.7040605@redhat.com>
Date: Tue, 23 Dec 2014 09:30:01 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.comp.emulators.kvm.devel
To: Andy Lutomirski <luto@amacapital.net>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        glommer@gmail.com
Subject: Re: [RFC 0/2] x86, vdso, pvclock: Cleanups and speedups
References: <cover.1419295081.git.luto@amacapital.net> <549917F6.1080504@redhat.com> <CALCETrUtf=a9wRYwftJxNB6Smrf0pXS43qPd37XO0_mxrGJ-Cg@mail.gmail.com>
In-Reply-To: <CALCETrUtf=a9wRYwftJxNB6Smrf0pXS43qPd37XO0_mxrGJ-Cg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 23/12/2014 09:16, Andy Lutomirski wrote:
> Any thoughts as to whether it should be tagged for stable?  I haven't
> looked closely enough at the old pvclock code or the generated code to
> have much of an opinion there.  It'll be a big speedup for non-pvclock
> users at least.

Yes, please.

Paolo
