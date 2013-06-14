Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab3FNRo4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 13:44:56 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:59695 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009Ab3FNRoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 13:44:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Olof Johansson <olof@lixom.net>
Cc: Jonas Jensen <jonas.jensen@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] ARM: mach-moxart: add MOXA ART SoC files
Date: Fri, 14 Jun 2013 19:44:57 +0200
Message-ID: <6334975.lLWqiA43Az@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.3; x86_64; ; )
In-Reply-To: <CAOesGMgznJXWN5nE-2igC-d0YY_aFk0Q1D_5p95oTZM-VTs5qw@mail.gmail.com>
References: <1371040448-28742-1-git-send-email-jonas.jensen@gmail.com> <2428901.voOA9oET8R@wuerfel> <CAOesGMgznJXWN5nE-2igC-d0YY_aFk0Q1D_5p95oTZM-VTs5qw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:yi0GGRBT4eu88274R+4TwEhzJfaereDV8+dLXCwyhZr
 V3tAPaVzBdub2D6ED7Um2XWIV/zf69epPgJD7Otwv83VwnlE2n
 oLB1kaIyHcexKoYH8GokxkJaXszdeU9dU9DMWw3ZB4lrBf5jiW
 6RCEnnp74EBy9JUdS3yr9jYIQHLU23qRIQzSqzKLM6C7F0sy8b
 7KXjsV+ppRpbM9kt4sLr2BX8TvUj7Iq5g0CWwLlLBk8EELUT8B
 gzZsd88D4zY0HtWQBHwW4+eefyYLzvST2muR1afr1CpQZMwXE/
 CC0lOhZQIk4xmfZOMJGGR/6D9jbfMINRB3ifcCkZIIufJ5e57R
 7TGqOQmKJGncgMuh1emA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 June 2013 09:41:36 Olof Johansson wrote:
> I sort of presumed that there might be need for _some_ platform code
> later on, just not quite yet, so I didn't want to be quite that
> drastic. I suppose leaving it with the trivial file for now is OK, and
> we can make a sweeping change down the road in case we want to clean
> up and consolidate all the trivial platforms.

Yes, good idea.

	Arnd
