Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbaFIOJV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 10:09:21 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:50163 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaFIOJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 10:09:18 -0400
Message-ID: <1402322954.11505.10.camel@umadbro>
Subject: Re: [RFC 0/4 v2] cfg80211/mac80211: Add new interface type for OCB
 (Outside the Context of a BSS) mode
From: Rostislav Lisovy <lisovy@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Date: Mon, 09 Jun 2014 16:09:14 +0200
In-Reply-To: <1401826536.4157.54.camel@jlt4.sipsolutions.net>
References: <1401468984-24575-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 (sfid-20140530_185636_416967_38B72FDB) <1401826536.4157.54.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-03 at 22:15 +0200, Johannes Berg wrote:
> it's unclear to me how the bitrate is
> selected, are there even different bitrates?

My understanding is that since we are using OFDM we have to support at
least 3, 6, 12 Mb/s data rates (says 802.11-2012, Chapter 18.1.1, second
paragraph). How to choose it when transmitting? That should probably be
defined in some standard built on top of "802.11p" -- the European
"Intelligent Transport System" standard ETSI EN 302 663 defines
different channels in 5.9 Ghz band along with the "default data
rate" (Table 2, Chapter 4.3). For example Control Channel (nr. 180) has
data rate 6 Mb/s, while Service Channel 2 (nr. 178) has data rate 12
Mb/s.

Regards;
Rostislav

