Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861Ab3APOL0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 09:11:26 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:37719 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab3APOLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 09:11:25 -0500
Message-ID: <1358345501.22862.10.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH] {cfg,mac}80211.h: fix some kernel-doc warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: Yacine Belkadi <yacine.belkadi.1@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 16 Jan 2013 15:11:41 +0100
In-Reply-To: <1357995254-2318-1-git-send-email-yacine.belkadi.1@gmail.com> (sfid-20130112_135436_590066_4364BBD9)
References: <1357995254-2318-1-git-send-email-yacine.belkadi.1@gmail.com>
	 (sfid-20130112_135436_590066_4364BBD9)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I totally missed your email before.

> Warning(include/net/cfg80211.h:334): No description found for return value of       'cfg80211_get_chandef_type'
> 
> These warnings are only reported when scripts/kernel-doc runs in verbose mode.
> 
> Fix:
> In comments, use "Return:" to describe function return values.

I wasn't even aware of this, is that new? Anyway, applied, thanks.

johannes

