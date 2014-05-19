Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbaESOvU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 10:51:20 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:33735 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631AbaESOvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 10:51:18 -0400
Message-ID: <1400511063.4273.10.camel@jlt4.sipsolutions.net>
Subject: Re: [RFC 1/2] cfg80211: Add channel flags limiting availability to
 OCB mode only
From: Johannes Berg <johannes@sipsolutions.net>
To: Rostislav Lisovy <lisovy@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Date: Mon, 19 May 2014 16:51:03 +0200
In-Reply-To: <1400510945-24868-2-git-send-email-rostislav.lisovy@fel.cvut.cz> (sfid-20140519_164914_781166_025BC930)
References: <1400510945-24868-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 <1400510945-24868-2-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 (sfid-20140519_164914_781166_025BC930)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-19 at 16:49 +0200, Rostislav Lisovy wrote:
> IEEE 802.11p operates in its own 5.9GHz band. When there will
> be a record for the 5.9GHz band in the regulatory daemon,
> it must be limited to the OCB mode only -- using the newly
> added flags.

This patch is fine, but insufficient - you should also do something with
the new flags?

johannes

