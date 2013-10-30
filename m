Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab3J3LYK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 07:24:10 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34223 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab3J3LYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 07:24:07 -0400
Date: Wed, 30 Oct 2013 12:24:05 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Luciano Coelho <luca@coelho.fi>,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, freemangordon@abv.bg,
        aaro.koskinen@iki.fi, sre@ring0.de, joni.lapilainen@gmail.com,
        David Gnedt <david.gnedt@davizone.at>
Subject: Re: [PATCH 02/16] wl1251: fix scan behaviour while not associated
Message-ID: <20131030112405.GA8204@amd.pavel.ucw.cz>
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
 <1382819655-30430-3-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1382819655-30430-3-git-send-email-pali.rohar@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2013-10-26 22:34:01, Pali Rohár wrote:
> From: David Gnedt <david.gnedt@davizone.at>
> 
> With a dissacociated card I often encoutered very long scan delays.
> 
> My guess is that it has something to do with the cards DTIM handling and
> another firmware bug mentioned in the TI WLAN driver, which is described as
> the card may never end scanning if the channel is overloaded because it
> can't send probe requests. I think the firmware somehow also tries to
> receive DTIM messages when the BSSID is not set. Therefore most of the time
> it waits for DTIM messages and can't do scanning work.
> 
> Anyway we can workaround this misbehaviour by setting the HIGH_PRIORITY
> bit for scans in disassociated state.
> 
> Signed-off-by: David Gnedt <david.gnedt@davizone.at>

I guess you should add your Signed-off-by: here (as you are sending
the patch forward).

Other than that:

Reviewed-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
