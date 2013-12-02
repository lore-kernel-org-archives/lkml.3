Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab3LBT6f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:58:35 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:64228 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755971Ab3LBT6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:58:31 -0500
MIME-Version: 1.0
In-Reply-To: <20131202154329.GC1799@hercules.my.domain>
References: <20131202154329.GC1799@hercules.my.domain>
Date: Mon, 2 Dec 2013 14:58:31 -0500
X-Google-Sender-Auth: 8EiumkxZ0GJF3aIE5VV_Bv9Kh0M
Message-ID: <CA+5PVA4X+OV3L5oKL1XoPQ4=9pi_wd6MwMaSuqjyy57pAapxxw@mail.gmail.com>
Subject: Re: [ANNOUNCE] Linux 3.11.y.z extended stable support
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Ubuntu kernel team <kernel-team@lists.ubuntu.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 2, 2013 at 10:43 AM, Luis Henriques
<luis.henriques@canonical.com> wrote:
> Since Ubuntu 13.10 "Saucy Salamander" uses the 3.11 kernel, the Ubuntu
> kernel team will pick up stable maintenance where Greg KH left off[1]
> with 3.11.10 (thanks a lot, Greg!).
>
> The Ubuntu kernel team is pleased to announce that we will be
> providing extended stable support for the Linux 3.11 kernel until
> August 2014 as a third party effort maintained on our infrastructure.
>
> Our linux-3.11.y{-queue,-review} stable branches will fork from
> 3.11.10 and will be published here:
>
>     git://kernel.ubuntu.com/ubuntu/linux.git
>
> We will use the same stable request/review workflow and follow the
> standard upstream stable kernel rules.  More details are available at
> http://wiki.ubuntu.com/Kernel/Dev/ExtendedStable
>
> We welcome any feedback and contribution to this effort.  We will be
> posting the first review cycle patch set in a week or two.

I might have asked this already before, but if I did I've forgotten
the answer.  Apologies if so.

Why not do this on the kernel.org infrastructure and treat it like all
the other kernel.org stable releases?  I'm confused why it needs to be
"forked" when it's following the same rules.  It seems like it could
just pick up with 3.11.11 and carry on.

josh
