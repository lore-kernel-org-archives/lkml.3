Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbaEZJfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 05:35:43 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:58344 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649AbaEZJfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 05:35:41 -0400
Message-ID: <1401096928.19055.7.camel@jlt4.sipsolutions.net>
Subject: Re: [RFC 1/2] cfg80211: Add channel flags limiting availability to
 OCB mode only
From: Johannes Berg <johannes@sipsolutions.net>
To: Rostislav Lisovy <lisovy@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Date: Mon, 26 May 2014 11:35:28 +0200
In-Reply-To: <1401095199.11908.6.camel@umadbro> (sfid-20140526_110645_465239_E133F549)
References: <1400510945-24868-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 <1400510945-24868-2-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 (sfid-20140519_164914_781166_025BC930) <1400511063.4273.10.camel@jlt4.sipsolutions.net>
	 <1401095199.11908.6.camel@umadbro> (sfid-20140526_110645_465239_E133F549)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-26 at 11:06 +0200, Rostislav Lisovy wrote:
> On Mon, 2014-05-19 at 16:51 +0200, Johannes Berg wrote:
> > This patch is fine, but insufficient - you should also do something
> > with
> > the new flags?
> 
> That's definitely a good point. I think the biggest issue is that the
> flags can't be checked only with the knowledge of the 'wiphy' but they
> are related to the 'vif' type -- this prohibits checking in the
> cfg80211_chandef_usable() (I assume).
> 
> Would the following be sufficient?

Well, you'll find that if you address my comments on the other patch,
all of this discussion goes away easily.

johannes

