Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428AbaBJI2a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 03:28:30 -0500
Received: from s3.sipsolutions.net ([144.76.43.152]:44948 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbaBJI22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 03:28:28 -0500
Message-ID: <1392020862.4128.1.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH] net: rfkill-regulator: Add devicetree support.
From: Johannes Berg <johannes@sipsolutions.net>
To: Marek Belisko <marek@goldelico.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        linville@tuxdriver.com, davem@davemloft.net, grant.likely@linaro.org,
        neilb@suse.de, hns@goldelico.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Mon, 10 Feb 2014 09:27:42 +0100
In-Reply-To: <1391802529-29861-1-git-send-email-marek@goldelico.com> (sfid-20140207_204900_539631_47DCB6B7)
References: <1391802529-29861-1-git-send-email-marek@goldelico.com>
	 (sfid-20140207_204900_539631_47DCB6B7)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-07 at 20:48 +0100, Marek Belisko wrote:

> +#define RFKILL_TYPE_ALL		(0)
> +#define RFKILL_TYPE_WLAN	(1)
> +#define RFKILL_TYPE_BLUETOOTH	(2)
> +#define RFKILL_TYPE_UWB		(3)
> +#define RFKILL_TYPE_WIMAX	(4)
> +#define RFKILL_TYPE_WWAN	(5)
> +#define RFKILL_TYPE_GPS		(6)
> +#define RFKILL_TYPE_FM		(7)
> +#define RFKILL_TYPE_NFC		(8)

This seems like a bad idea since there's an enum elsewhere in userspace
API already.

johannes

