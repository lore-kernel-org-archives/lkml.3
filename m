Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbaKKKDy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 05:03:54 -0500
Received: from s3.sipsolutions.net ([5.9.151.49]:57395 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752275AbaKKKDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 05:03:52 -0500
Message-ID: <1415700220.2163.3.camel@sipsolutions.net>
Subject: Re: [PATCH 1/1] linux-wireless: Added psk in struct
 cfg80211_connect_params needed for offloading 4way handshake to driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: "Gautam (Gautam Kumar) Shukla" <gautams@broadcom.com>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jithu Jance <jithu@broadcom.com>, Sreenath S <sreenats@broadcom.com>
Date: Tue, 11 Nov 2014 11:03:40 +0100
In-Reply-To: <5461DCC9.5050702@broadcom.com>
References: <DF163EE1A432BF4BBE6B2088220663A67437BD@SJEXCHMB06.corp.ad.broadcom.com>
	 <1415698161.2163.0.camel@sipsolutions.net> <5461DCC9.5050702@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-11 at 10:54 +0100, Arend van Spriel wrote:

> > Also, there's a competing approach from QCA that's far more suited.
> 
> I probably was not paying attention to it, but would you have a
> reference to this.

... digs around in email ...

http://mid.gmane.org/1343907187-6686-1-git-send-email-qca_vkondrat@qca.qualcomm.com

Anyway, looking back at that, it wasn't really all that different, just
a bit more complete maybe.

johannes

