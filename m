Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365AbaJISxY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 14:53:24 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:59566 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbaJISxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 14:53:14 -0400
Message-ID: <1412880786.1828.64.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH 1/1 net-next] mac80211: directly return
 ieee80211_vif_use_reserved_context()
From: Johannes Berg <johannes@sipsolutions.net>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Thu, 09 Oct 2014 20:53:06 +0200
In-Reply-To: <1412879782-8818-1-git-send-email-fabf@skynet.be>
References: <1412879782-8818-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-09 at 20:36 +0200, Fabian Frederick wrote:
> No need to store ieee80211_vif_use_reserved_context result and test it before returning.

Makes sense, applied. Please break commit log lines to <=72 characters
in the future though.

johannes

