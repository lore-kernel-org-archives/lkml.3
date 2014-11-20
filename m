Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446AbaKTAnu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 19:43:50 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:46379 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641AbaKTAns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 19:43:48 -0500
MIME-Version: 1.0
In-Reply-To: <CAK=WgbZE7_WrsNz5E+MDX7j2tAGEjv91zeCgqhB=Jsiu0+d8vw@mail.gmail.com>
References: <1410553499-55951-1-git-send-email-s-anna@ti.com>
	<1410553499-55951-6-git-send-email-s-anna@ti.com>
	<CAK=WgbZE7_WrsNz5E+MDX7j2tAGEjv91zeCgqhB=Jsiu0+d8vw@mail.gmail.com>
Date: Wed, 19 Nov 2014 16:43:46 -0800
Message-ID: <CAJAp7OisV3UrL45UgRb0tMudyCJHe-xsmsRYV0uGG3P4PReHnA@mail.gmail.com>
Subject: Re: [PATCHv6 5/5] hwspinlock/omap: add support for dt nodes
From: Bjorn Andersson <bjorn@kryo.se>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Suman Anna <s-anna@ti.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>, Tony Lindgren <tony@atomide.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 11:14 AM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> Hi Suman,
[..]
>
> Does this mean you allow nodes not to have the base_id property? How
> do we protect against multiple nodes not having a base_id property
> then?
>
> Implicitly assuming a base_id value (zero in this case) may not be always safe.
>

Hi Ohad,

I still have a huge problem understanding the awesomeness with the
"base_id". If you have a SoC with 2 hwlock blocks; say 8+8 locks, used
for interaction with e.g. a modem and a video core respectively.
Why would you in either remote system offset the locks with 8?
Wouldn't e.g the modem use locks hwlock0:0-7 and video core use locks
hwlock1:0-7?

What systems use more than one hwlock block and do you know of any
reasons why these hwlocks are globally numbered?

Regards,
Bjorn
