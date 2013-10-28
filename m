Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545Ab3J1O5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 10:57:24 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:34523 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330Ab3J1O5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 10:57:09 -0400
Message-ID: <1382972215.17956.30.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH 16/16] wl1251: Add sysfs file address for setting
 permanent mac address
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Luciano Coelho <luca@coelho.fi>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, freemangordon@abv.bg,
        aaro.koskinen@iki.fi, pavel@ucw.cz, sre@ring0.de,
        joni.lapilainen@gmail.com
Date: Mon, 28 Oct 2013 15:56:55 +0100
In-Reply-To: <1382971562.1542.6.camel@dcbw.foobar.com>
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
	 <201310281449.58170@pali> <1382968522.17956.11.camel@jlt4.sipsolutions.net>
	 <201310281500.24159@pali> <1382971562.1542.6.camel@dcbw.foobar.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-10-28 at 09:46 -0500, Dan Williams wrote:

> If the device doesn't actually *have* a permanent MAC address, then it
> shouldn't be returning one via ethtool, and should return an error for
> ETHTOOL_GPERMADDR.

There's currently no provision for that, but I agree it would be better
to do so.

johannes

