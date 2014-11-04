Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbaKDJ0A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 04:26:00 -0500
Received: from s3.sipsolutions.net ([5.9.151.49]:52287 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509AbaKDJZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 04:25:53 -0500
Message-ID: <1415093148.2064.5.camel@sipsolutions.net>
Subject: Re: [PATCH 0/2 v3] cfg80211: mac80211: 802.11p OCB mode support
From: Johannes Berg <johannes@sipsolutions.net>
To: Rostislav Lisovy <lisovy@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de, burak.simsek@volkswagen.de,
        Emmanuel Thierry <emmanuel.thierry@yogoko.fr>,
        laszlo.virag@commsignia.com,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Date: Tue, 04 Nov 2014 10:25:48 +0100
In-Reply-To: <1415007199-31506-1-git-send-email-rostislav.lisovy@fel.cvut.cz> (sfid-20141103_103325_972796_F4E0AE3F)
References: <1415007199-31506-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 (sfid-20141103_103325_972796_F4E0AE3F)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-03 at 10:33 +0100, Rostislav Lisovy wrote:
> The IEEE 802.11p amendment (already part of IEEE 802.11-2012)
> specifies usage of 5 and 10 MHz wide channels in 5.9GHz band for
> vehicular environment. All the 802.11p compliant devices should
> be set to the newly added operation mode -- OCB (Outside the
> Context of a BSS). No authentication/association is necessary to
> communicate. The only parameter to be configured is the channel
> (central frequency and bandwidth) to communicate on. The channel
> has to be known a priori. It is set during the 'ocb join'
> operation (sent via netlink message from user-space).
> 
> This patchset adds the OCB mode, OCB join and leave handling
> (nl80211, cfg80211, mac80211), 802.11p EDCA parameters
> modification, RX and TX path (for unicast/broadcast messages).

Applied, thanks for all the changes.

johannes

