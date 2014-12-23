Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbaLWHVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 02:21:33 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:47731 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbaLWHVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 02:21:31 -0500
Message-ID: <549917F6.1080504@redhat.com>
Date: Tue, 23 Dec 2014 08:21:26 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        Marcelo Tosatti <mtosatti@redhat.com>
CC: Gleb Natapov <gleb@kernel.org>, kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        glommer@gmail.com
Subject: Re: [RFC 0/2] x86, vdso, pvclock: Cleanups and speedups
References: <cover.1419295081.git.luto@amacapital.net>
In-Reply-To: <cover.1419295081.git.luto@amacapital.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 23/12/2014 01:39, Andy Lutomirski wrote:
> This is a dramatic simplification and speedup of the vdso pvclock read
> code.  Is it correct?
> 
> Andy Lutomirski (2):
>   x86, vdso: Use asm volatile in __getcpu
>   x86, vdso, pvclock: Simplify and speed up the vdso pvclock reader

Patch 1 is ok,

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

For patch 2 I will defer to Marcelo and Glauber (and the Xen folks).

Paolo
