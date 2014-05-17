Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757061AbaEQEyz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 00:54:55 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:35842 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757011AbaEQEyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 00:54:53 -0400
MIME-Version: 1.0
In-Reply-To: <200048151.0RTJzuPcGp@vostro.rjw.lan>
References: <1400237477-24831-1-git-send-email-chander.kashyap@linaro.org>
	<CAKohpomYMcisB-UHp7TOEdxvQ9-1VzyRshQh=P-dQqYOuBz-5g@mail.gmail.com>
	<200048151.0RTJzuPcGp@vostro.rjw.lan>
Date: Sat, 17 May 2014 10:24:53 +0530
Message-ID: <CAKohpokQk7jf30gLEX_UTaACGi_mPuSdWxeONEir3+U=0x3JPw@mail.gmail.com>
Subject: Re: [PATCH] PM / OPP: fix incorrect OPP count handling in of_init_opp_table
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Chander Kashyap <chander.kashyap@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>, Pavel Machek <pavel@ucw.cz>,
        "Brown, Len" <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chander Kashyap <k.chander@samsung.com>,
        Inderpal Singh <inderpal.s@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 May 2014 04:33, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> Is this -stable material?  If so, which -stable?

3.7+
