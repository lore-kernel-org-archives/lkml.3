Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250Ab3HAH3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 03:29:22 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:53893 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab3HAH3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 03:29:21 -0400
Message-ID: <1375342151.8608.0.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH v2] mac80211: use oneshot blink API for LED triggers
From: Johannes Berg <johannes@sipsolutions.net>
To: Fabio Baltieri <fabio.baltieri@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 01 Aug 2013 09:29:11 +0200
In-Reply-To: <1374746426-22030-1-git-send-email-fabio.baltieri@gmail.com> (sfid-20130725_120041_569594_897514BC)
References: <1374746426-22030-1-git-send-email-fabio.baltieri@gmail.com>
	 (sfid-20130725_120041_569594_897514BC)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-25 at 12:00 +0200, Fabio Baltieri wrote:
> Change mac80211 LED trigger code to use the generic
> led_trigger_blink_oneshot() API for transmit and receive activity
> indication.
> 
> This gives a better feedback to the user, as with the new API each
> activity event results in a visible blink, while a constant traffic
> results in a continuous blink at constant rate.

Applied.

johannes

