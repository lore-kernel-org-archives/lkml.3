Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab3J3LfG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 07:35:06 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34563 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257Ab3J3LfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 07:35:04 -0400
Date: Wed, 30 Oct 2013 12:35:02 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Luciano Coelho <luca@coelho.fi>,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, freemangordon@abv.bg,
        aaro.koskinen@iki.fi, sre@ring0.de, joni.lapilainen@gmail.com,
        David Gnedt <david.gnedt@davizone.at>
Subject: Re: [PATCH 07/16] wl1251: configure hardware en-/decryption for
 monitor mode
Message-ID: <20131030113502.GA8763@amd.pavel.ucw.cz>
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
 <1382819655-30430-8-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1382819655-30430-8-git-send-email-pali.rohar@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2013-10-26 22:34:06, Pali Rohár wrote:
> From: David Gnedt <david.gnedt@davizone.at>
> 
> Disable hardware encryption (DF_ENCRYPTION_DISABLE) and decryption
> (DF_SNIFF_MODE_ENABLE) via wl1251_acx_feature_cfg while monitor interface is
> present.
> 
> Signed-off-by: David Gnedt <david.gnedt@davizone.at>

You need to sign off the patch, otherwise looks ok.

Reviewed-by: Pavel Machek <pavel@ucw.cz>

Thanks,
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
