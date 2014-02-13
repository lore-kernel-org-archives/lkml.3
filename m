Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652AbaBMFUY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 00:20:24 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:59700 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaBMFUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 00:20:22 -0500
MIME-Version: 1.0
In-Reply-To: <20140212150627.GB5496@localhost.localdomain>
References: <CALZhoSQZQcM0yKTw1=ZkYz3Z_3X2QxLk0vCw6gKXW55HSrVEdw@mail.gmail.com>
	<alpine.DEB.2.02.1401221459590.4260@ionos.tec.linutronix.de>
	<CALZhoSSSOZKwDok2ZHumeZAs0R88SC6bU2BaL54U3TU6jgoaZA@mail.gmail.com>
	<CAKohpomMZ0TAN2e6N76_g4ZRzxd5vZ1XfuZfxrP7GMxfTNiLVw@mail.gmail.com>
	<20140212150627.GB5496@localhost.localdomain>
Date: Thu, 13 Feb 2014 10:50:19 +0530
Message-ID: <CAKohpomAmkvHkhqWe685M0W7N2hs0JHuSzrJ+QKmoj-w6QkMRA@mail.gmail.com>
Subject: Re: Is it ok for deferrable timer wakeup the idle cpu?
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Lei Wen <adrian.wenl@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 February 2014 20:36, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> The change I'm applying is strongly inspired from the above. Can I use your Signed-off-by?

Sure :)
