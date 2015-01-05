Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbbAEKD3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 05:03:29 -0500
Received: from mail-oi0-f48.google.com ([209.85.218.48]:41903 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231AbbAEKD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 05:03:28 -0500
MIME-Version: 1.0
In-Reply-To: <1420449884.1898.3.camel@sipsolutions.net>
References: <CAAXZBWLOKL8Uu9No_tQga34nFurmeK2HP9qixO1jCXw1Y0t5HA@mail.gmail.com>
	<1420449884.1898.3.camel@sipsolutions.net>
Date: Mon, 5 Jan 2015 10:03:27 +0000
Message-ID: <CAAXZBWJD02F81gJkhvLFZcpCzJahr-qsUUgbqheUfrc_BP0CjA@mail.gmail.com>
Subject: Re: [PATCH] rfkill: parameters documentation
From: Andrew Clausen <andrew.p.clausen@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johannes,

On 5 January 2015 at 09:24, Johannes Berg <johannes@sipsolutions.net> wrote:
> Looks fine to me (though the commit message shouldn't contain the email
> "boilerplate" of "hi all" etc - should just be

Ah, sorry for the extra noise.

> However I'm not sure I should apply this through my tree?

I think you're right -- it makes sense to put it in your tree, and
merge it down the track.  (I don't think I've submitted a kernel patch
since pre-git days, so sorry for the confusion.)

Cheers,
Andrew
