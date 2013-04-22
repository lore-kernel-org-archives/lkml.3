Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab3DVNzE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 09:55:04 -0400
Received: from mail-ia0-f171.google.com ([209.85.210.171]:65047 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab3DVNzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 09:55:01 -0400
MIME-Version: 1.0
In-Reply-To: <1366637397.8637.7.camel@jlt4.sipsolutions.net>
References: <1366236369-543-1-git-send-email-bzhao@marvell.com>
	<1366236590.8217.64.camel@jlt4.sipsolutions.net>
	<CAMcMvsjh4y=84hM+dCcFvb1xxSq5c3HqTBg6VyaCZkh5s=E5yA@mail.gmail.com>
	<1366637397.8637.7.camel@jlt4.sipsolutions.net>
Date: Mon, 22 Apr 2013 06:55:00 -0700
X-Google-Sender-Auth: s47SmeqXDIssvzUbVRMQnY06564
Message-ID: <CAMcMvshGf1y3_pA+KxEGNFBC=mnZHD6XQh__hNHfAtAmJ37UNg@mail.gmail.com>
Subject: Re: [PATCH] net-sysfs: Add entry for nl80211 interface type
From: Paul Stewart <pstew@chromium.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bing Zhao <bzhao@marvell.com>, linux-netdev@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 6:29 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
> On Wed, 2013-04-17 at 15:14 -0700, Paul Stewart wrote:
> > I believe the documents for "iw" state explicitly that we shouldn't
> > screen-scrape it?
>
> Well, you specifically control your system. I'd also be happy to add
> some (maybe a bit hidden) commands to print out _just_ the (numeric)
> type, to aid scripting?


No need.  I already made the necessary changes in userspace to switch
to nl80211 to retrieve the iftype.  Both Bing and I are done
proselytizing at this point. :-)

>
> All I'm trying to say with that though is that
> you shouldn't rely on specific output formatting, particularly not with
> scan results and "iw list" etc.
>
> johannes
>
>
