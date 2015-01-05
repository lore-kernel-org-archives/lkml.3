Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086AbbAEWFY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 17:05:24 -0500
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:65107 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753130AbbAEWFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 17:05:22 -0500
Message-ID: <1420495519.14308.29.camel@x220>
Subject: Re: [PATCH] Revert "ipw2200: select CFG80211_WEXT"
From: Paul Bolle <pebolle@tiscali.nl>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arend van Spriel <arend@broadcom.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>, Jiri Kosina <jkosina@suse.cz>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 05 Jan 2015 23:05:19 +0100
In-Reply-To: <1420484224.9459.16.camel@sipsolutions.net>
References: <1420297188.2397.3.camel@tiscali.nl>
	 <CD467A59-F563-439B-BA82-954AB27AD9CC@holtmann.org>
	 <CA+55aFzYSiUkntraMrHEhMzkt35Ft2p9E3cT7ejwQOBDwKvcOg@mail.gmail.com>
	 <1420324124.9624.60.camel@x220> <54AA641C.7050307@broadcom.com>
	 <1420479510.14308.23.camel@x220>
	 (sfid-20150105_183907_807502_81C08416) <1420484224.9459.16.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Jan 2015 22:05:19.0419 (UTC) FILETIME=[B1A4E8B0:01D02933]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-05 at 19:57 +0100, Johannes Berg wrote:
> Multiple other groups of ioctls could be converted in similar patches,
> until at the end you can completely remove ipw_wx_handlers and rely
> entirely on cfg80211's wext compatibility.
> 
> So far the theory - in practice nobody cared enough to start working on
> any of these drivers, let alone actually has the hardware today.

So my suggestion to make ipw2200 no longer use cfg80211_wext_giwname()
would actually be backwards. What's actually needed, in theory, is to
use more of what's provided under CFG80211_WEXT (and, I guess, less of
what's provided under WIRELESS_EXT). Did I get that right?

Thanks,


Paul Bolle

