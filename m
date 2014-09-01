Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793AbaIAMHu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 08:07:50 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:47401 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500AbaIAMHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 08:07:47 -0400
Message-ID: <1409573258.2703.0.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH 2/2] nl80211.c: Fixed the wdev_id being used
 uninitialized.
From: Johannes Berg <johannes@sipsolutions.net>
To: Shakil A Khan <shakilk1729@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, linville@tuxdriver.com
Date: Mon, 01 Sep 2014 14:07:38 +0200
In-Reply-To: <1409572467-50908-1-git-send-email-shakilk1729@gmail.com> (sfid-20140901_135440_786712_355C815A)
References: <1409572467-50908-1-git-send-email-shakilk1729@gmail.com>
	 (sfid-20140901_135440_786712_355C815A)
Content-Type: text/plain
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +	u64 wdev_id = 0;

it's not used uninitialized, NACK.

johannes

