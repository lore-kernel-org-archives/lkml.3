Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933606Ab3GSSrJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 14:47:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46721 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697Ab3GSSrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 14:47:08 -0400
Message-ID: <51E989A0.8050103@zytor.com>
Date: Fri, 19 Jul 2013 11:46:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ramkumar Ramachandra <artagnon@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [QUERY] lguest64
References: <CALkWK0n7zedKD4tnxKh-qMuDnMJ5RXjnPJ9EUWT=cCgiokX11A@mail.gmail.com> <51E97779.3020103@zytor.com> <CALkWK0ktHB34WkcYvGt_BOFoQbvbFJANDqGPUdZjT+Ui29pqAg@mail.gmail.com>
In-Reply-To: <CALkWK0ktHB34WkcYvGt_BOFoQbvbFJANDqGPUdZjT+Ui29pqAg@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2013 10:42 AM, Ramkumar Ramachandra wrote:
> H. Peter Anvin wrote:
>> We want to reduce pvops and pvops users, not increase them...
> 
> I see.  So the future is true virtualization which exposes the
> underlying hardware, like KVM?  Why do bare-metal virtualizers like
> Xen employ paravirtualization?  Also, where does UML stand?
> 

UML, lguest and Xen were done before the x86 architecture supported
hardware virtualization.  UML does paravirtualization without needing
hooks all over the kernel, which is really impressive, but unfortunately
rather slow, which makes it useful mostly for testing.

I did at some point wonder if UML would make a decent base platform for
something similar to libguestfs, but on KVM-enabled hardware KVM seems
like the better option (and is indeed what libguestfs uses.)

	-hpa


