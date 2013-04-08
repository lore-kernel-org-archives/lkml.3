Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936509Ab3DHOc5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 10:32:57 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:53052 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936284Ab3DHOc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 10:32:56 -0400
Message-ID: <1365431569.25475.16.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH v2] mac80211_hwsim: Register and bind to driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Martin Pitt <martin.pitt@ubuntu.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Date: Mon, 08 Apr 2013 16:32:49 +0200
In-Reply-To: <20130408093001.GE2818@piware.de>
References: <20130408093001.GE2818@piware.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-08 at 11:30 +0200, Martin Pitt wrote:
> Properly register our mac80211_hwsim_driver, attach it to the platform bus.
> Bind newly created hwsim devices to that driver, so that our wlan devices get
> a proper "driver" sysfs attribute.
> 
> This makes mac80211_hwsim interfaces work with NetworkManager.

Applied.

johannes

