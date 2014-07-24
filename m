Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950AbaGXLIE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 07:08:04 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:33021 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755181AbaGXLIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 07:08:01 -0400
Message-ID: <1406200070.14675.15.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH] cfg80211: Try multiple bandwidths when checking usable
 channels.
From: Johannes Berg <johannes@sipsolutions.net>
To: Rostislav Lisovy <lisovy@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Date: Thu, 24 Jul 2014 13:07:50 +0200
In-Reply-To: <1404998752-7446-1-git-send-email-rostislav.lisovy@fel.cvut.cz> (sfid-20140710_152613_503086_D7BCA204)
References: <1404998752-7446-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 (sfid-20140710_152613_503086_D7BCA204)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-10 at 15:25 +0200, Rostislav Lisovy wrote:

>  const struct ieee80211_reg_rule *freq_reg_info(struct wiphy *wiphy,
> -					       u32 center_freq);
> +					       u32 center_freq,
> +					       u32 desired_bw_khz);

You can't just change a function prototype without changing all the
callers...

johannes

