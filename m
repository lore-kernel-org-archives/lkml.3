Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab3JUKWw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 06:22:52 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:60001 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab3JUKWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 06:22:51 -0400
Message-ID: <1382350961.14310.42.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH] mac80211: document IEEE80211_HW_SUPPORTS_HT_CCK_RATES
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 21 Oct 2013 12:22:41 +0200
In-Reply-To: <1382251529-22540-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1382251529-22540-1-git-send-email-michael.opdenacker@free-electrons.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-10-20 at 08:45 +0200, Michael Opdenacker wrote:
> This patch documents the IEEE80211_HW_SUPPORTS_HT_CCK_RATES flag
> in ieee80211_hw_flags.
> 
> Without this, you get countless warnings in "make htmldocs".

I already have an equivalent patch with correct documentation :)

johannes

