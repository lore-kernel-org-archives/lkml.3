Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756455AbaDHJyu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 05:54:50 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:37720 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaDHJyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 05:54:49 -0400
Message-ID: <1396950886.5936.12.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH 1/4] cfg80211: Add attributes describing prohibited
 channel bandwidth
From: Johannes Berg <johannes@sipsolutions.net>
To: Rostislav Lisovy <lisovy@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Date: Tue, 08 Apr 2014 11:54:46 +0200
In-Reply-To: <1396445515-5808-2-git-send-email-rostislav.lisovy@fel.cvut.cz> (sfid-20140402_153205_125660_90C9D001)
References: <1396445515-5808-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 <1396445515-5808-2-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 (sfid-20140402_153205_125660_90C9D001)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-02 at 15:31 +0200, Rostislav Lisovy wrote:
> Since there are frequency bands (e.g. 5.9GHz) allowing channels
> with only 10 or 5 MHz bandwidth, this patch adds attributes that
> allow keeping track about this information.
> 
> When channel attributes are reported to user-space, make sure to
> not break old tools, i.e. if the 'split wiphy dump' is enabled,
> report the extra attributes (if present) describing the bandwidth
> restrictions.  If the 'split wiphy dump' is not enabled,
> completely omit those channels that have flags set to either
> IEEE80211_CHAN_NO_10MHZ or IEEE80211_CHAN_NO_20MHZ.

I think you should probably squash patches 1 and 2, since otherwise you
could use the new channels?

Anyway, the patches don't seem to apply on mac80211-next, please rebase.

johannes

