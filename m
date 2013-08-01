Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab3HARWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 13:22:44 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:34671 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab3HARWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 13:22:43 -0400
MIME-Version: 1.0
In-Reply-To: <51E989A0.8050103@zytor.com>
References: <CALkWK0n7zedKD4tnxKh-qMuDnMJ5RXjnPJ9EUWT=cCgiokX11A@mail.gmail.com>
 <51E97779.3020103@zytor.com> <CALkWK0ktHB34WkcYvGt_BOFoQbvbFJANDqGPUdZjT+Ui29pqAg@mail.gmail.com>
 <51E989A0.8050103@zytor.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Thu, 1 Aug 2013 22:52:02 +0530
Message-ID: <CALkWK0=T6aqpqHKf=601EPc9+4cvgJ053xBU2HxmJuf2dVXoxw@mail.gmail.com>
Subject: Re: [QUERY] lguest64
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> UML, lguest and Xen were done before the x86 architecture supported
> hardware virtualization.

[...]

> but on KVM-enabled hardware KVM seems
> like the better option (and is indeed what libguestfs uses.)

While we're still on the topic, I'd like a few clarifications. From
your reply, I got the impression that KVM the only mechanism for
non-pvops virtualization.  This seems quite contrary to what I read on
lwn about ARM virtualization [1]. In short, ARM provides a "hypervisor
mode", and the article says

  "the virtualization model provided by ARM fits the Xen
hypervisor-based virtualization better than KVM's kernel-based model"

The Xen people call this "ARM PVH" (as opposed to ARM PV, which does
not utilize hardware extensions) [2]. Although I wasn't able to find
much information about the hardware aspect, what ARM provides seems to
be quite different from VT-x and AMD-V. I'm also confused about what
virt/kvm/arm is.

Thanks.

[1]: http://lwn.net/Articles/513940/
[2]: http://www.xenproject.org/developers/teams/arm-hypervisor.html
