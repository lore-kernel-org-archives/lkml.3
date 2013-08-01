Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085Ab3HAHSq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 03:18:46 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:57108 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab3HAHSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 03:18:45 -0400
MIME-Version: 1.0
In-Reply-To: <20130731153115.GA5233@pd.tnic>
References: <CALkWK0n7zedKD4tnxKh-qMuDnMJ5RXjnPJ9EUWT=cCgiokX11A@mail.gmail.com>
	<51E97779.3020103@zytor.com>
	<87zjte9iah.fsf@rustcorp.com.au>
	<CABpLfohrweJd0=0eFJDO7dv2HHxx_mbP0uySMDrsZZZXExdXug@mail.gmail.com>
	<20130731153115.GA5233@pd.tnic>
Date: Thu, 1 Aug 2013 10:18:44 +0300
Message-ID: <CABpLfoi8gG5o6Qp2e8m1-GnP5+dKjH4bwDJorN+6g0EybXaa6g@mail.gmail.com>
Subject: Re: [QUERY] lguest64
From: Mike Rapoport <mike.rapoport@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 6:31 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Wed, Jul 31, 2013 at 12:39:23PM +0300, Mike Rapoport wrote:
>> There are plenty virtual machines in EC2, Rackspace, HP and other
>> clouds that do not have hardware virtualization. I believe that
>> running a hypervisor on them may be pretty interesting.
>
> Interesting how?
>
> How interesting is it really to run nested on a public
> surveillance^Wcloud platform vs say, using nested kvm on your own
> machine?

There are people that use public clouds^Wsurveliance platforms. Why do
they prefer these platforms over kvm on their own machines is another
question. But, it is their choice and their right to use whatever
platform they'd like. I've only suggested to provide them with ability
to use nested virtualizatoin on their platform...

> What are those very important use cases which warrant growing more of
> that pvops gunk^Wcreativity?

For instance, you can run several exact copies of OpenStack deployment
on Amazon EC2 :-)

> :-)
>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --

-- 
Sincerely yours,
Mike.
