Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221Ab3A3WQf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 17:16:35 -0500
Received: from ares07.inai.de ([5.9.24.206]:50343 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755872Ab3A3WQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 17:16:33 -0500
Date: Wed, 30 Jan 2013 23:16:31 +0100 (CET)
From: Jan Engelhardt <jengelh@inai.de>
To: Tom St Denis <tstdenis@elliptictech.com>
cc: Alexander Holler <holler@ahsoftware.de>, Borislav Petkov <bp@alien8.de>,
        Eric Dumazet <erdnetdev@gmail.com>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
        David Miller <davem@davemloft.net>,
        steffen klassert <steffen.klassert@secunet.com>,
        herbert@gondor.hengli.com.au, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Michal Kubecek <mkubecek@suse.cz>,
        Mike Galbraith <bitbucket@online.de>
Subject: Re: IPsec AH use of ahash
In-Reply-To: <650108746.93086.1358690064783.JavaMail.root@elliptictech.com>
Message-ID: <alpine.LNX.2.01.1301302303180.11666@nerf07.vanv.qr>
References: <650108746.93086.1358690064783.JavaMail.root@elliptictech.com>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sunday 2013-01-20 14:54, Tom St Denis wrote:
>> 
>> > You should really try running checkpatch.pl over code that's
>> > already in the kernel before you call out new contributors on it.
>> >
>> > How is this supposed to not be adversarial when I can't even use
>> > the Kernel source itself as a reference?
>> 
>> In case of the kernel the chicken and egg problem can be answered
>> without any questions, most source existed before checkpatch.pl
>> (evolved
>> to the current state).
>
>We clearly have different interpretations of the word "maintainer"
>then... If they're not maintaining the code then are they really the
>maintainers of it?

Maintainers maintain code. From own experience - I too have some
projects that are *only* "maintained" - that includes maintaining the
status quo, keeping it compiling and taking patches that require no
more than 5 minutes to think about.

To support users, especially ones with fire-and-forget submissions,
an "integrator" (for the lack of a better word for cleaning guy)
or "developer" to take up their posting is required.
But it often lacks one or more.
