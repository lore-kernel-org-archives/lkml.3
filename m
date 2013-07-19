Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880Ab3GSUgf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 16:36:35 -0400
Received: from mail-vb0-f49.google.com ([209.85.212.49]:49602 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab3GSUge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 16:36:34 -0400
MIME-Version: 1.0
In-Reply-To: <51E989A0.8050103@zytor.com>
References: <CALkWK0n7zedKD4tnxKh-qMuDnMJ5RXjnPJ9EUWT=cCgiokX11A@mail.gmail.com>
	<51E97779.3020103@zytor.com>
	<CALkWK0ktHB34WkcYvGt_BOFoQbvbFJANDqGPUdZjT+Ui29pqAg@mail.gmail.com>
	<51E989A0.8050103@zytor.com>
Date: Fri, 19 Jul 2013 22:36:33 +0200
Message-ID: <CAFLxGvxbYo+6nHThM70UuohA7dM+myJsF5FXcg_eS4S7-8AzVQ@mail.gmail.com>
Subject: Re: [QUERY] lguest64
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ramkumar Ramachandra <artagnon@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 8:46 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 07/19/2013 10:42 AM, Ramkumar Ramachandra wrote:
>> H. Peter Anvin wrote:
>>> We want to reduce pvops and pvops users, not increase them...
>>
>> I see.  So the future is true virtualization which exposes the
>> underlying hardware, like KVM?  Why do bare-metal virtualizers like
>> Xen employ paravirtualization?  Also, where does UML stand?

UML is a nice thingy because it is Linux ported to itself, but it has
limitations.
Mostly it's speed (pagefaults and system calls are really slow) and it
supports only x86/x86_64.

I use UML on systems where KVM is not available.

--
Thanks,
//richard
