Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933179AbaFIOVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 10:21:48 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:52898 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045AbaFIOVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 10:21:45 -0400
Message-ID: <1402323702.11505.18.camel@umadbro>
Subject: Re: [RFC 1/4] cfg80211: Add channel flags limiting availability to
 OCB mode only
From: Rostislav Lisovy <lisovy@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Liraz Perelmooter <liraz.perelmooter@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>,
        wireless-regdb@lists.infradead.org, green@qti.qualcomm.com
Date: Mon, 09 Jun 2014 16:21:42 +0200
In-Reply-To: <20140603221837.GU26450@wotan.suse.de>
References: <1401468984-24575-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 <1401468984-24575-2-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 <1401825693.4157.44.camel@jlt4.sipsolutions.net>
	 <20140603221837.GU26450@wotan.suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Luis;
Thank you for the introduction in the wireless-regdb mailing-list.

On Wed, 2014-06-04 at 00:18 +0200, Luis R. Rodriguez wrote:
> Rostislav, can you provide documentation references which would
> clarify
> the stance on 802.11p and restrictions for only allowing  OCB mode?

If I may cite the 802.11-2012 standard:
-- 1st Quote
4.3.11 STA transmission of data frames outside the context of a BSS

Communication of data frames when dot11OCBActivated is true might take
place in a frequency band that is dedicated for its use, and such a band
might require licensing depending on the regulatory domain. A STA for
which dot11OCBActivated is true initially transmits and receives on a
channel known in advance, either through regulatory designation or some
other out-of-band communication.
-- End of quote

-- 2nd Quote
Annex E (normative) Country elements and operating classes
E.2.3 5.9 GHz band in the United States (5.850–5.925 GHz)
...
STAs shall have dot11OCBActivated set to true.

E.2.4 5.9 GHz band in Europe (5.855–5.925 GHz)
STAs shall have dot11OCBActivated set to true.
-- end of quote

Regards;
Rostislav

