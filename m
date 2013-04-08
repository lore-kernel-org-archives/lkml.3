Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936497Ab3DHXML (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 19:12:11 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:51882 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935512Ab3DHXMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 19:12:09 -0400
MIME-Version: 1.0
In-Reply-To: <201304090003.47056.chunkeey@googlemail.com>
References: <CAJ-Vmo=LVSzdEo6DhfOVT_0JHCTMmdPU1zGfMuBmhmr8QuDmJQ@mail.gmail.com>
	<CAJ-VmomS_=1=QLZrfdD4vhu9Qy0w2JNQxEFrkt_OKjWetrWY4w@mail.gmail.com>
	<CAFSJ42b7DD9UVtzT7YWhaEchzwpde0yW=pS3nJVeMCHoVQGBqQ@mail.gmail.com>
	<201304090003.47056.chunkeey@googlemail.com>
Date: Mon, 8 Apr 2013 16:12:07 -0700
X-Google-Sender-Auth: eXv1DKZzI8eD0aXIh6Ofd-UWPSc
Message-ID: <CAJ-VmomksDSNvTpKQpNRRQx+QboSVHpby7V4qq4rngqVkTvf+A@mail.gmail.com>
Subject: Re: Version number policy!
From: Adrian Chadd <adrian@freebsd.org>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Eugene Krasnikov <k.eugene.e@gmail.com>, Kalle Valo <kvalo@adurom.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath9k_htc_fw <ath9k_htc_fw@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm a FreeBSD user. I know what it's like to have an alternate, out of
linux implementation of ext2/3 that doesn't implement all of the
features.

I also know what kinds of crap happens when you try mounting a more
recent extX filesystem on an earlier kernel. Ie, it doesn't
necessarily end well. :-)

Anyway, there's been a lot of good points in this discussion. Let's
keep it in mind as we slowly march forward.

There's only like, 60k of generated binary code on these things. Let's
not overthink things too much for now. :)



Adrian
