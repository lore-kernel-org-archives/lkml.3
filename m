Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932474Ab3DXLFy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 07:05:54 -0400
Received: from sipsolutions.net ([144.76.43.152]:50091 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932353Ab3DXLFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 07:05:51 -0400
X-Greylist: delayed 540 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Apr 2013 07:05:51 EDT
Message-ID: <1366801001.11111.8.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH] mac80211_hwsim: correctly register the platform driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: martin.pitt@ubuntu.com, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dcbw@redhat.com
Date: Wed, 24 Apr 2013 12:56:41 +0200
In-Reply-To: <1366778405-7584-1-git-send-email-sasha.levin@oracle.com>
References: <1366778405-7584-1-git-send-email-sasha.levin@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-24 at 00:40 -0400, Sasha Levin wrote:
> Not registering a platform_driver would make us access garbage
> when the platform callbacks under driver_register() kicks in.

Applied, thanks.

johannes

