Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbaGUKUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 06:20:47 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:45311 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754276AbaGUKUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 06:20:45 -0400
Message-ID: <1405938028.32255.17.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH] mac80211: Parse IEEE80211_RADIOTAP_RATE on TX
From: Johannes Berg <johannes@sipsolutions.net>
To: Rostislav Lisovy <lisovy@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Date: Mon, 21 Jul 2014 12:20:28 +0200
In-Reply-To: <1404995261-6626-1-git-send-email-rostislav.lisovy@fel.cvut.cz> (sfid-20140710_142756_935664_A8B88F97)
References: <1404995261-6626-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 (sfid-20140710_142756_935664_A8B88F97)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-10 at 14:27 +0200, Rostislav Lisovy wrote:
> Add support for parsing radiotap field IEEE80211_RADIOTAP_RATE
> for transmitted frames. Use the provided datarate value in
> info->control.rates[] array so it will be used for transmission.
> 
> Signed-off-by: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
> ---
> This feature is essential for Transmit Datarate Control (TDC)
> in future implementation of IEEE 802.11-2012 "Wireless Access
> for the Vehicular Environment" support.

It seems like an extremely bad idea to base your implementation of WAVE
on monitor mode with injection.

Why can't you add a proper datapath?

johannes

