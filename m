Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935238Ab3DHJ2w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:28:52 -0400
Received: from www.piware.de ([213.9.93.70]:37995 "EHLO www.piware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934118Ab3DHJ2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:28:51 -0400
Date: Mon, 8 Apr 2013 11:28:49 +0200
From: Martin Pitt <martin.pitt@ubuntu.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] mac80211_hwsim: Register and bind to driver
Message-ID: <20130408092849.GD2818@piware.de>
References: <20130408090633.GB2818@piware.de>
 <1365412374.25475.2.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365412374.25475.2.camel@jlt4.sipsolutions.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Johannes,

Johannes Berg [2013-04-08 11:12 +0200]:
> I think you forgot to update the error path to unregister the driver.

Oops, thanks for spotting. Sending [PATCH v2].

Martin
-- 
Martin Pitt                        | http://www.piware.de
Ubuntu Developer (www.ubuntu.com)  | Debian Developer  (www.debian.org)
