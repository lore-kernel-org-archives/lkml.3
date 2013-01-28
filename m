Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791Ab3A1KOJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 05:14:09 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:53722 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226Ab3A1KOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 05:14:06 -0500
MIME-Version: 1.0
In-Reply-To: <1359133168-14879-1-git-send-email-gregory.clement@free-electrons.com>
References: <1359133168-14879-1-git-send-email-gregory.clement@free-electrons.com>
Date: Mon, 28 Jan 2013 11:14:05 +0100
Message-ID: <CACRpkdZNNvDB03O-ZYKDYMXwG7cBD0zwwonP303gWzjE4JXbhg@mail.gmail.com>
Subject: Re: [PATCH 0/2] Improvement for pca953x drivers
From: Linus Walleij <linus.walleij@linaro.org>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com>,
        Roland Stigge <stigge@antcom.de>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 5:59 PM, Gregory CLEMENT
<gregory.clement@free-electrons.com> wrote:

> those two patches are the begining of the improvement work we have
> spoken about earlier. I started with the two patches you sent.

Thanks for doing this!! :-)

> I've just made a small fix to make it build on the 2nd patch so I keep
> your autorship and signed-off.

OK I don't care about authorship & such stuff, the important thing
to me is that the code works and looks nice and maintainable.

> I've compiled and run it, but as I don't have support for the pca905
> interrupt on my board, I can't say it didn't break anything. Maybe
> this time again Maxime will be willing to test it.

I will apply the patches and then Maxime can shout if it breaks :-)

> For the remaining improvement related to the PWA and MMP #ifdef, I
> hope to be able to work on it this week-end.

Excellent, thanks!

Yours,
Linus Walleij
