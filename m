Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab3H1WGd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 18:06:33 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60407 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468Ab3H1WGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 18:06:31 -0400
MIME-Version: 1.0
In-Reply-To: <1761440.cq52yMKNRv@vostro.rjw.lan>
References: <1375216733-6740-1-git-send-email-zoran.markovic@linaro.org>
	<3196266.rMZQj4Yosc@vostro.rjw.lan>
	<CAME+o4n8HqvGtAGX0wO+Zs_pdanKuhai6T3jg2V1Q4nWzxKk9A@mail.gmail.com>
	<1761440.cq52yMKNRv@vostro.rjw.lan>
Date: Wed, 28 Aug 2013 15:06:31 -0700
Message-ID: <CAME+o4mKnbF+PzEC=JWLE+Tm=4p-1pegcnaKGYTcT07URzCPGQ@mail.gmail.com>
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

> Is there any practical reason why it should go into the next release?

Android folks find this useful, albeit a debug feature.

Zoran
