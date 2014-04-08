Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541AbaDHJuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 05:50:39 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:37712 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbaDHJuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 05:50:37 -0400
Message-ID: <1396950631.5936.10.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH 4/4] mac80211: Update conf_is_ht() to work properly with
 5/10MHz channels
From: Johannes Berg <johannes@sipsolutions.net>
To: Rostislav Lisovy <lisovy@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Date: Tue, 08 Apr 2014 11:50:31 +0200
In-Reply-To: <1396445515-5808-5-git-send-email-rostislav.lisovy@fel.cvut.cz> (sfid-20140402_153211_146608_D1A4795F)
References: <1396445515-5808-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 <1396445515-5808-5-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 (sfid-20140402_153211_146608_D1A4795F)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-02 at 15:31 +0200, Rostislav Lisovy wrote:
> The channels with 5/10MHz bandwidth are not HT. We have to
> reflect this in conf_is_ht() function which returns whether the
> particular channel is HT or not.

Applied.

johannes

