Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384AbbANIzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:55:19 -0500
Received: from s3.sipsolutions.net ([5.9.151.49]:58140 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932330AbbANIzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 03:55:15 -0500
Message-ID: <1421225707.1950.28.camel@sipsolutions.net>
Subject: Re: [PATCH] iw: Add OCB mode handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Rostislav Lisovy <lisovy@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de, burak.simsek@volkswagen.de,
        bernd.lehmann@volkswagen.de,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Date: Wed, 14 Jan 2015 09:55:07 +0100
In-Reply-To: <1421066997-8676-1-git-send-email-rostislav.lisovy@fel.cvut.cz> (sfid-20150112_135009_513914_2ADE15D0)
References: <1421066997-8676-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 (sfid-20150112_135009_513914_2ADE15D0)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-12 at 13:49 +0100, Rostislav Lisovy wrote:
> Since the commit 6e0bd6c35b021dc73a81ebd1ef79761233c48b50
> ("cfg80211: 802.11p OCB mode handling") and
> 239281f803e2efdb77d906ef296086b6917e5d71
> ("mac80211: 802.11p OCB mode support")
> does the Linux kernel support OCB mode. This commit adds
> proper OCB mode handling.
> 
> Modify the command for device type setting to support OCB mode.
> Add commands for "joining" and "leaving" the OCB mode network.
> When joining two arguments are mandatory -- frequency and
> channel bandwidth (5 or 10 MHz).

Applied, thanks.

johannes

