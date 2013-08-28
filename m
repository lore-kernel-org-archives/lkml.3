Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab3H1Rpt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 13:45:49 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:37543 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab3H1Rpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 13:45:47 -0400
MIME-Version: 1.0
In-Reply-To: <3196266.rMZQj4Yosc@vostro.rjw.lan>
References: <1375216733-6740-1-git-send-email-zoran.markovic@linaro.org>
	<CAME+o4=uNFDjz8yFJEQR8P4dwki4U0iBv-FrixTA_TFxWctDSA@mail.gmail.com>
	<3196266.rMZQj4Yosc@vostro.rjw.lan>
Date: Wed, 28 Aug 2013 10:45:45 -0700
Message-ID: <CAME+o4n8HqvGtAGX0wO+Zs_pdanKuhai6T3jg2V1Q4nWzxKk9A@mail.gmail.com>
Subject: Re: [RFC PATCHv3] drivers: power: Detect device suspend/resume lockup
 and log event in pstore.
From: Zoran Markovic <zoran.markovic@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Benoit Goby <benoit@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        Colin Cross <ccross@android.com>, Todd Poynor <toddpoynor@google.com>,
        San Mehat <san@google.com>, John Stultz <john.stultz@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,
> It doesn't look too bad from a quick look, but there's a couple of things
> I don't like in it still (relatively minor).

If there are things you would like changed in this patch, please let
me know. It would be nice to catch the 3.12 merge window.
Thanks,
- Zoran
