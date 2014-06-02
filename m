Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310AbaFBGhV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 02:37:21 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:60059 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbaFBGhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 02:37:18 -0400
MIME-Version: 1.0
In-Reply-To: <5387B7B6.70102@ti.com>
References: <cover.1401191054.git.viresh.kumar@linaro.org>
	<ce68a1ba333ab080a2428242d8fa4d4629064a4d.1401191054.git.viresh.kumar@linaro.org>
	<5387B7B6.70102@ti.com>
Date: Mon, 2 Jun 2014 12:07:17 +0530
Message-ID: <CAKohpok__TGBnO52ALbrqpkg53p+wcZ+sXLu7fAo38R1x6GFGA@mail.gmail.com>
Subject: Re: [PATCH V4 4/8] driver/core: cpu: initialize opp table
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Nishanth Menon <nm@ti.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Ips Gandhi <inderpal.s@samsung.com>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, "Brown, Len" <len.brown@intel.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Shawn Guo <shawn.guo@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 May 2014 04:11, Nishanth Menon <nm@ti.com> wrote:
> The change so far is a improvement in error handling -> which,
> personally I find nice, but not necessarily related to the $subject or
> covered in commit message. I suggest splitting that specific change
> out as a patch of it's own.

I would be required to do this here:

if (!error)
    of_init_opp_table(**);

And so did this change as part of this patch :), probably rafael doesn't
feel a need of this and so has asked me to do a resend of a single patch
(reported by Sachin) ..

So, will leave it as is unless he wants me to send it again :)

For this and other patches, thanks for your review.
