Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935081Ab3BTUBJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 15:01:09 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:53441 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934553Ab3BTUBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 15:01:05 -0500
MIME-Version: 1.0
In-Reply-To: <CANeU7QnMzYuG6iiU3nLh4k0dGFMEDOyfUDQgxQSKj20_y-oL+Q@mail.gmail.com>
References: <CANeU7QmbzX4Tx1Dtu6xOiYzr6h6_8tPQvVG32Wvkt=5wAwEEAg@mail.gmail.com>
	<20130219100849.72d2330b@jbarnes-desktop>
	<CANeU7QmJb+yUGu9mVgq=_pHhvpPu6ORrikm=E6PkuHpOz9OREA@mail.gmail.com>
	<20130219125217.6b6f55ff@jbarnes-desktop>
	<CANeU7QnQmKYXHA=aEuRGZDc7hVdY6037i=+s_n3FZNMN2njDsw@mail.gmail.com>
	<CAKMK7uG7TgiAn0ZQ=E_-QBPNAVhTSxpORkX3Z1mY=54mgTzM-g@mail.gmail.com>
	<CANeU7QnMzYuG6iiU3nLh4k0dGFMEDOyfUDQgxQSKj20_y-oL+Q@mail.gmail.com>
Date: Wed, 20 Feb 2013 12:01:04 -0800
X-Google-Sender-Auth: 7m-4-3c83AtmuSI0lIPaU4kXkAc
Message-ID: <CANeU7QnvstoCzgFhB_6VM8TbthpEc_wKYFY=JX1GwUR6mRtHvQ@mail.gmail.com>
Subject: Re: i915 black screen introduced by ACPI changes
From: Chris Li <lkml@chrisli.org>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
        robert.moore@intel.com, feng.tang@intel.com, len.brown@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 11:45 AM, Chris Li <lkml@chrisli.org> wrote:
> Here is the dmesg with "drm.debug=0xe". It is from the tip of git
> kernel. The computer has the black screen.
> Let me know what else do you need.

More probing. When I use type "reboot" via ssh. The machine will
able to exit the black screen  and show normal text based terminal
for the systemd shutdown message.

However, even if I switch the default run level to 3, without starting
X. The black screen still appear. I guess the black screen disappear
when kernel stop using virtual terminal.

I also verify that, in the good 3.6.x kernel. I am able to logout from
X and log back in without trigger black screen of death.

Chris
