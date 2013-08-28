Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab3H1Ula (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 16:41:30 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:40122 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381Ab3H1Ul3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 16:41:29 -0400
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
Date: Wed, 28 Aug 2013 22:52:13 +0200
Message-ID: <1761440.cq52yMKNRv@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAME+o4n8HqvGtAGX0wO+Zs_pdanKuhai6T3jg2V1Q4nWzxKk9A@mail.gmail.com>
References: <1375216733-6740-1-git-send-email-zoran.markovic@linaro.org> <3196266.rMZQj4Yosc@vostro.rjw.lan> <CAME+o4n8HqvGtAGX0wO+Zs_pdanKuhai6T3jg2V1Q4nWzxKk9A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 28, 2013 10:45:45 AM Zoran Markovic wrote:
> Hi Rafael,
> > It doesn't look too bad from a quick look, but there's a couple of things
> > I don't like in it still (relatively minor).
> 
> If there are things you would like changed in this patch, please let
> me know. It would be nice to catch the 3.12 merge window.

Well, it's not in my queue to be honest.

Is there any practical reason why it should go into the next release?

Rafael

