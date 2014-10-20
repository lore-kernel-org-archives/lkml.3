Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbaJTJlv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 05:41:51 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:36221 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753055AbaJTJls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 05:41:48 -0400
Message-ID: <1413798105.10246.9.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH 1/4] mac80211: OCB mode + join and leave handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Rostislav Lisovy <lisovy@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de, burak.simsek@volkswagen.de,
        Emmanuel Thierry <emmanuel.thierry@yogoko.fr>,
        laszlo.virag@commsignia.com,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Date: Mon, 20 Oct 2014 11:41:45 +0200
In-Reply-To: <1413480005.16330.15.camel@umadbro> (sfid-20141016_192008_718892_BA5E5317)
References: <1410445822-6559-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 <1410445822-6559-2-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 (sfid-20140911_163047_025105_09D86D44) <1412843005.1828.14.camel@jlt4.sipsolutions.net>
	 <1413477188.15416.10.camel@umadbro> <1413480005.16330.15.camel@umadbro>
	 (sfid-20141016_192008_718892_BA5E5317)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-16 at 19:20 +0200, Rostislav Lisovy wrote:

> Now I realized it is not that easy (and I confused "interface running"
> and being "connected to the network"). There seems not to be a solid
> indication that we are no longer "connected" to the network.

Oops, ignore my previous reply.

> I think a field
> 	enum {
> 		IEEE80211_OCB_STOPPED,
> 		IEEE80211_OCB_JOINED,
> 	} state;
> in struct ieee80211_if_ocb seems to be appropriate.

Yes, that seems doable. Maybe just a "bool joined" would work just as
well, but it won't make a difference in the result - whichever you
prefer.

johannes

