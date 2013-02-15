Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946Ab3BOTn3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 14:43:29 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:58639 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab3BOTn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 14:43:27 -0500
MIME-Version: 1.0
In-Reply-To: <20130215193736.GD4351@the-dreams.de>
References: <1360953682-25066-1-git-send-email-dianders@chromium.org>
	<20130215193736.GD4351@the-dreams.de>
Date: Fri, 15 Feb 2013 11:43:25 -0800
X-Google-Sender-Auth: mSdue7dCRVKzFze9BL1xPOrgmgU
Message-ID: <CAD=FV=VTJN3bU1rpMyjDMvX1SYZJWoJCiNtHNe+nDrtwnXqTXA@mail.gmail.com>
Subject: Re: [PATCH] i2c: mux: Remove unneeded platform_set_drvdata to NULL in remove
From: Doug Anderson <dianders@chromium.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Peter Korsgaard <peter.korsgaard@barco.com>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfram,

On Fri, Feb 15, 2013 at 11:37 AM, Wolfram Sang <wsa@the-dreams.de> wrote:
> I think we should do this at least I2C subsystem wide (51 occasions of
> setting some *_drvdata to NULL), even better kernel-wide. Patching
> individual drivers won't cut the confusion around this issue, I am
> afraid.

I did it "mux" directory wide and this was the only instance.  ;)
I'll re-send with I2C subsystem wide.  I probably won't attempt the
whole kernel wide at this point, but would be very happy if someone
else wanted to!  :)

Thanks for the review!

-Doug
