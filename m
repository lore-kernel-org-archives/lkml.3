Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933742AbaJ2Pb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 11:31:28 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:38603 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933329AbaJ2Pb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 11:31:27 -0400
Message-ID: <1414596680.1827.6.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH] mac80211_hwsim: release driver when
 ieee80211_register_hw fails
From: Johannes Berg <johannes@sipsolutions.net>
To: Junjie Mao <eternal.n08@gmail.com>
Cc: Martin Pitt <martin.pitt@ubuntu.com>,
        Fengguang Wu <fengguang.wu@intel.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 29 Oct 2014 16:31:20 +0100
In-Reply-To: <1414459907-7509-1-git-send-email-eternal.n08@gmail.com> (sfid-20141028_023301_948024_70359C07)
References: <1414459907-7509-1-git-send-email-eternal.n08@gmail.com>
	 (sfid-20141028_023301_948024_70359C07)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-28 at 09:31 +0800, Junjie Mao wrote:
> The driver is not released when ieee80211_register_hw fails in
> mac80211_hwsim_create_radio, leading to the access to the unregistered (and
> possibly freed) device in platform_driver_unregister:

Applied.

johannes

