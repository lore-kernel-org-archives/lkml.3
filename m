Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab3J1NpU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 09:45:20 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:34002 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756604Ab3J1NpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 09:45:18 -0400
Message-ID: <1382967905.17956.8.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH 16/16] wl1251: Add sysfs file address for setting
 permanent mac address
From: Johannes Berg <johannes@sipsolutions.net>
To: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Luciano Coelho <luca@coelho.fi>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, freemangordon@abv.bg,
        aaro.koskinen@iki.fi, pavel@ucw.cz, sre@ring0.de,
        joni.lapilainen@gmail.com
Date: Mon, 28 Oct 2013 14:45:05 +0100
In-Reply-To: <1382819655-30430-17-git-send-email-pali.rohar@gmail.com> (sfid-20131026_224040_591629_24EA42A4)
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
	 <1382819655-30430-17-git-send-email-pali.rohar@gmail.com>
	 (sfid-20131026_224040_591629_24EA42A4)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-10-26 at 22:34 +0200, Pali Rohár wrote:
> Driver wl1251 generating mac address randomly at startup and there is no way to
> set permanent mac address via SET_IEEE80211_PERM_ADDR. This patch export sysfs
> file which can set permanent mac address by userspace helper program. Patch is
> needed for devices which do not store mac address in internal wl1251 eeprom.

This doesn't really seem like a good idea since you can also just use
'ip' or whatever to set the MAC address.

johannes

