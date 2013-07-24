Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359Ab3GXIOj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 04:14:39 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:49115 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab3GXIOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 04:14:37 -0400
Message-ID: <1374653665.8180.0.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH] mac80211: use oneshot blink API for LED triggers
From: Johannes Berg <johannes@sipsolutions.net>
To: Fabio Baltieri <fabio.baltieri@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 24 Jul 2013 10:14:25 +0200
In-Reply-To: <1374624581-6012-2-git-send-email-fabio.baltieri@gmail.com> (sfid-20130724_020950_576315_9E59DD81)
References: <1374624581-6012-1-git-send-email-fabio.baltieri@gmail.com>
	 <1374624581-6012-2-git-send-email-fabio.baltieri@gmail.com>
	 (sfid-20130724_020950_576315_9E59DD81)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-24 at 02:09 +0200, Fabio Baltieri wrote:
> Changes mac80211 LED trigger code to use the generic
> led_trigger_blink_oneshot() API for transmit and receive activity
> indication.
> 
> This gives a better feedback to the user, as with the new API each
> activity event results in a visible blink, while a constant traffic
> results in a continuous blink at constant rate.

This seems a little pointless since our throughput-based trigger can do
very similar (but somewhat better) behaviour? Maybe that should just be
the default instead, with some sane default setup values?

(Regardless of that, you also have indentation problems in your patch)

johannes

