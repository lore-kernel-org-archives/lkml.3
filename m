Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977Ab3J1XuR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 19:50:17 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:24510 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757709Ab3J1XuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 19:50:15 -0400
Message-ID: <1383004209.3779.54.camel@bwh-desktop.uk.level5networks.com>
Subject: Re: [PATCH 16/16] wl1251: Add sysfs file address for setting
 permanent mac address
From: Ben Hutchings <bhutchings@solarflare.com>
To: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
CC: Luciano Coelho <luca@coelho.fi>,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <freemangordon@abv.bg>,
        <aaro.koskinen@iki.fi>, <pavel@ucw.cz>, <sre@ring0.de>,
        <joni.lapilainen@gmail.com>
Date: Mon, 28 Oct 2013 23:50:09 +0000
In-Reply-To: <1382819655-30430-17-git-send-email-pali.rohar@gmail.com>
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
	 <1382819655-30430-17-git-send-email-pali.rohar@gmail.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-20252.005
X-TM-AS-Result: No--9.559000-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-10-26 at 22:34 +0200, Pali Rohár wrote:
> Driver wl1251 generating mac address randomly at startup and there is no way to
> set permanent mac address via SET_IEEE80211_PERM_ADDR. This patch export sysfs
> file which can set permanent mac address by userspace helper program. Patch is
> needed for devices which do not store mac address in internal wl1251 eeprom.
[...]

This belongs in struct wl12xx_platform_data or (better) Device Tree
properties.  It definitely should not be settable once the device is
registered.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

