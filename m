Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751304AbaGOEOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 00:14:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49748 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbaGOEO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 00:14:29 -0400
Message-ID: <53C4AA97.2050105@zytor.com>
Date: Mon, 14 Jul 2014 21:14:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Is espfix64's double-fault thing OK on Xen?
References: <CALCETrXrVNKNQtxncfOth5OqaSOC7KygerbB-+QQb4_VKESVsA@mail.gmail.com> <53C40D83.3090501@zytor.com> <CALCETrU44CM5=hSOMQGB6eEM2g-h6y5_+-SwoMwu+-qp-Pxd7g@mail.gmail.com> <CALCETrVz7a7RVLhYTrGvHkJR2dGHJbRuATOaWaXgkrSABR7YFA@mail.gmail.com> <CALCETrU9dmM+bsQYwULjiqw5+erKsu5yUmHJDGYUW1wpcdp-5Q@mail.gmail.com> <CALCETrWG-dQL8ipJ8cO3wfbYKA=mAv3CS4-1JFwmBXF3pUbAwg@mail.gmail.com> <53C45857.6050605@zytor.com> <CALCETrUrAZsoPttFhAd384OJ27ixwC_NCYFMWuMzyDqoKBmTmQ@mail.gmail.com>
In-Reply-To: <CALCETrUrAZsoPttFhAd384OJ27ixwC_NCYFMWuMzyDqoKBmTmQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2014 07:46 PM, Andy Lutomirski wrote:
> 
> On espfix-less kernels (Xen and non-Xen), 16-bit CS w/ 16-bit SS
> always fails.  Native (32-bit or 64-bit, according to the binary) CS
> with 16-bit SS fails for sigreturn_32, but passes for sigreturn_64.  I
> find this somewhat odd.  Native ss always passes.
> 

espfix32 is disabled on Xen.

	-hpa

