Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161464Ab3DEFph (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 01:45:37 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:43891 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab3DEFpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 01:45:33 -0400
Date: Fri, 5 Apr 2013 13:45:19 +0800
From: Wang YanQing <udknight@gmail.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        rdunlap@infradead.org
Subject: Re: [PATCH] lib80211: make lib80211 can be enabled independently
Message-ID: <20130405054519.GA2073@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	Julian Calaby <julian.calaby@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	rdunlap@infradead.org
References: <20130404160130.GA2577@udknight>
 <CAGRGNgXj7mSF0Fgyjek4Xcc34N26WHtt4HMmHk7DOopaEPrYFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGRGNgXj7mSF0Fgyjek4Xcc34N26WHtt4HMmHk7DOopaEPrYFw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 05, 2013 at 10:51:30AM +1100, Julian Calaby wrote:
> Just as a bit of explanation for Johannes' NACK:
> 
> 1. The only reason lib80211 still exists is because a couple of
> in-tree drivers still use it. If this weren't the case, the code would
> have been removed a long time ago as it's been completely replaced by
> mac80211 and cfg80211. All modern drivers _must_ use mac80211 or
> cfg80211 without exception.
> 2. In general, there is no official in-kernel support for
> out-of-kernel drivers, regardless of quality, status or importance.
> 3. I believe that the in-tree brcmsmac driver already supports the
> Broadcom card you reference.

Hi Julian.

Thanks for your complete explanation.
I have tried in-tree brcmsmac driver and it works well,
I use it to send out this email! This is wonderful, then
I don't need to fix compilation errors about the old, ugly
and closed wl driver for my notebook with BCM43225 802.11b/g/n
every time I upgrade kernel.

Thanks Julian and all.
