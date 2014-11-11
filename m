Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbaKKJ3n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 04:29:43 -0500
Received: from s3.sipsolutions.net ([5.9.151.49]:57224 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333AbaKKJ3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 04:29:40 -0500
Message-ID: <1415698161.2163.0.camel@sipsolutions.net>
Subject: Re: [PATCH 1/1] linux-wireless: Added psk in struct
 cfg80211_connect_params needed for offloading 4way handshake to driver
From: Johannes Berg <johannes@sipsolutions.net>
To: "Gautam (Gautam Kumar) Shukla" <gautams@broadcom.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jithu Jance <jithu@broadcom.com>, Sreenath S <sreenats@broadcom.com>
Date: Tue, 11 Nov 2014 10:29:21 +0100
In-Reply-To: <DF163EE1A432BF4BBE6B2088220663A67437BD@SJEXCHMB06.corp.ad.broadcom.com>
References: <DF163EE1A432BF4BBE6B2088220663A67437BD@SJEXCHMB06.corp.ad.broadcom.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-11 at 05:56 +0000, Gautam (Gautam Kumar) Shukla wrote:
> For offloading 4 way handshake to driver, currently we don't have any
> member  of struct cfg80211_connect_params to pass PSK from supplicant
> to driver. I have added psk for the same and added rest of the code
> needed in nl80211.h and nl80211.c to parse and make it available to
> driver.
> From supplicant, we already have psk member field in assoc_params to
> use .
> 
> Tested on x86 linux.

Your commit message needs serious work.

Also, there's a competing approach from QCA that's far more suited.

In either case though, I'm going to ask which driver is going to use
this and when it's going to land in mainline.

johannes

