Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbaKDM6w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 07:58:52 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:37919 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbaKDM6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 07:58:49 -0500
Message-ID: <1415105926.11912.6.camel@umadbro>
Subject: Re: [PATCH 0/2 v3] cfg80211: mac80211: 802.11p OCB mode support
From: Rostislav Lisovy <lisovy@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de, burak.simsek@volkswagen.de,
        Emmanuel Thierry <emmanuel.thierry@yogoko.fr>,
        laszlo.virag@commsignia.com,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Date: Tue, 04 Nov 2014 13:58:46 +0100
In-Reply-To: <1415093148.2064.5.camel@sipsolutions.net>
References: <1415007199-31506-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 (sfid-20141103_103325_972796_F4E0AE3F) <1415093148.2064.5.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-04 at 10:25 +0100, Johannes Berg wrote:
> On Mon, 2014-11-03 at 10:33 +0100, Rostislav Lisovy wrote:
> > The IEEE 802.11p amendment (already part of IEEE 802.11-2012)
> > specifies usage of 5 and 10 MHz wide channels in 5.9GHz band for
> > vehicular environment. All the 802.11p compliant devices should
> > be set to the newly added operation mode -- OCB (Outside the
> > Context of a BSS). No authentication/association is necessary to
> > communicate. The only parameter to be configured is the channel
> > (central frequency and bandwidth) to communicate on. The channel
> > has to be known a priori. It is set during the 'ocb join'
> > operation (sent via netlink message from user-space).
> > 
> > This patchset adds the OCB mode, OCB join and leave handling
> > (nl80211, cfg80211, mac80211), 802.11p EDCA parameters
> > modification, RX and TX path (for unicast/broadcast messages).
> 
> Applied, thanks for all the changes.

Johannes, thank you for your help.

What do you think should be the next step? Until the new nl80211.h is
not in the 'iw' I will send some patches to the Atheros mailinglist
(adding OCB mode handling). Thereafter I will send patches for the 'iw'?

Best regards;
Rostislav

