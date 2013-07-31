Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799Ab3GaBk0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 21:40:26 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:35809 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab3GaBkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 21:40:25 -0400
MIME-Version: 1.0
In-Reply-To: <CAOesGMjG-6x0Qf0_FEQ7Rw5-p6Dyhf+Wi-tZ7x_cj7iq8UmjFg@mail.gmail.com>
References: <CAOesGMjG-6x0Qf0_FEQ7Rw5-p6Dyhf+Wi-tZ7x_cj7iq8UmjFg@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 31 Jul 2013 09:40:04 +0800
Message-ID: <CAGsJ_4zbugzzCMuG_85kY0RoBVBpTEBsxuVQ2c5y4tNtSLqmKA@mail.gmail.com>
Subject: Re: [ANNOUNCE] ARM kernel summit 2013, Oct 22-23
To: Olof Johansson <olof@lixom.net>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Kevin Hilman <khilman@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/7/30 Olof Johansson <olof@lixom.net>:
> As previous years, we are planning on hosting a ARM Kernel Summit
> attached to the main Kernel Summit, and we have graciously been given
> space to host it for two days, Oct 22-23 (Oct 23 is the track day for
> the main KS, so we're getting an extra day) in Edinburgh, UK.
>
> To make sure we get the right set of people invited, we're looking for
> people to propose topics they would like to see covered as part of the
> two-day aganda, as well as general invite requests. To request an
> invite or to propose a topic, please send an email to
> ksummit-2013-discuss@lists.linuxfoundation.org, and cc LAKML/LKML as
> appropriate. Please use the tag "[ARM ATTEND]" in the subject to
> distinguish these from the general KS ATTEND threads.
>
> It's pretty obvious that device trees and bindings are hot topics this
> year, with plenty of overlap between ARM and regular kernel summit and
> other subsystems. We are tentatively planning on dedicating Wednesday
> afternoon to the topic, to fit the regular agenda of KS track day to
> make sure as many interested parties as possible can attend. We'd
> still be interested in hearing specific topic requests in that area
> though.

It seems IKS and HMP of b.L are coming to hot. There is a prototype
now, and we need to push it to practice.
and as an user of both mainline and google Android, even there are
many Android patches in mainline now, we still need to maintain both
now. it seems google likes to rebase its patch series againest new
kernel version instead of merging everytime. so what about talking
Android mainlining project more?

>
>
> The group of us organizing and coordinating this year is:
>
> Arnd Bergmann
> Mark Brown
> Kevin Hilman
> Olof Johansson
> Grant Likely

-barry
