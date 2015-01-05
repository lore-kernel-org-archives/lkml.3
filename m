Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbbAEKNE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 05:13:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46237 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168AbbAEKNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 05:13:01 -0500
Date: Mon, 5 Jan 2015 11:12:57 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
cc: Paul Bolle <pebolle@tiscali.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert "ipw2200: select CFG80211_WEXT"
In-Reply-To: <1420452301.9459.3.camel@sipsolutions.net>
Message-ID: <alpine.LNX.2.00.1501051109350.16297@pobox.suse.cz>
References: <1420297188.2397.3.camel@tiscali.nl>  <CD467A59-F563-439B-BA82-954AB27AD9CC@holtmann.org>  <CA+55aFzYSiUkntraMrHEhMzkt35Ft2p9E3cT7ejwQOBDwKvcOg@mail.gmail.com>  <1420324124.9624.60.camel@x220> (sfid-20150103_232852_400842_25360CE9)
 <1420452301.9459.3.camel@sipsolutions.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Jan 2015, Johannes Berg wrote:

> Well, see the big thread over there with the revert that I'm tempted to
> not even read ...

I'd actually like to hear from you whether you share Emmanuel's point of 
view that my revert of your patch was inappropriate; I was really 
surprised that there might be even questions about that, given the obvious 
userspace wreckage.

Again, the only thing I really care for is the compatibility layer to 
userspace. I don't question at all the fact nl80211 provides much better 
functionality and its usage definitely should be encouraged.

Thanks,

-- 
Jiri Kosina
SUSE Labs
