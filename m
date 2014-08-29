Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbaH2LNF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 07:13:05 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:58624 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840AbaH2LNC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 07:13:02 -0400
Message-ID: <1409310778.4577.19.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH] mac80211: Parse IEEE80211_RADIOTAP_RATE on TX
From: Johannes Berg <johannes@sipsolutions.net>
To: Rostislav Lisovy <lisovy@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Date: Fri, 29 Aug 2014 13:12:58 +0200
In-Reply-To: <1408953158.8665.15.camel@umadbro> (sfid-20140825_095240_526526_2294AD5F)
References: <1404995261-6626-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 (sfid-20140710_142756_935664_A8B88F97) <1405938028.32255.17.camel@jlt4.sipsolutions.net>
	 <1408953158.8665.15.camel@umadbro> (sfid-20140825_095240_526526_2294AD5F)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-08-25 at 09:52 +0200, Rostislav Lisovy wrote:

> If I am not mistaken it is not possible to say that this feature may be
> useful as the general method for monitor-mode injection with datarate
> until there is some user-space utility really using/needing it?

Yes, this wasn't as much a comment on the patch as rather on your
implied approach for your userspace :)

That said, it's tricky, be cause much hardware doesn't allow to do this.
Maybe we should then have a feature flag or so rather than silently
ignoring the data?

johannes

