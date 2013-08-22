Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab3HVVx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 17:53:27 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:55849 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754105Ab3HVVxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 17:53:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Zoran Markovic <zoran.markovic@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Benoit Goby <benoit@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        Colin Cross <ccross@android.com>, Todd Poynor <toddpoynor@google.com>,
        San Mehat <san@google.com>, John Stultz <john.stultz@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCHv3] drivers: power: Detect device suspend/resume lockup and log event in pstore.
Date: Fri, 23 Aug 2013 00:04:02 +0200
Message-ID: <3196266.rMZQj4Yosc@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAME+o4=uNFDjz8yFJEQR8P4dwki4U0iBv-FrixTA_TFxWctDSA@mail.gmail.com>
References: <1375216733-6740-1-git-send-email-zoran.markovic@linaro.org> <CAME+o4=uNFDjz8yFJEQR8P4dwki4U0iBv-FrixTA_TFxWctDSA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 22, 2013 10:16:59 AM Zoran Markovic wrote:
> Rafael,
> I haven't seen any other proposals/alternatives on how to do this. Is
> there anything else we should do to get this upstream? I believe this
> is a valuable debug feature for Android and it now explicitly depends
> on pstore...

I haven't had a lot of time to look at this recently, sorry.

It doesn't look too bad from a quick look, but there's a couple of things
I don't like in it still (relatively minor).

I'll have a deeper look at it over the weekend (if nothing distracts me).

Thanks,
Rafael

